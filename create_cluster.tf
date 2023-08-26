# Need
# cluster security group - done
# workernode security group - done
# make it private - done
# set the service IP range
# Cluster addons
# ingress controller
# Autoscaling group name - done
# Configure remote access to nodes - done
# enable logging - done
# configmap


resource "aws_eks_cluster" "my-eks-cluster" {
  name = var.cluster_name 
  role_arn = aws_iam_role.eks-cluster-iam-role.arn

  vpc_config {
    subnet_ids              = aws_subnet.eks-subnets[*].id
	security_group_ids     = aws_security_group.eks-cluster-sg.id
	endpoint_public_access  = false
	endpoint_private_access = true
  }
  
  enabled_cluster_log_types = var.control_plane_logs
  
  depends_on = [
    aws_iam_role.eks-cluster-iam-role, 
	aws_cloudwatch_log_group.eks_cloudwatch_logs,
  ]
}

data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.my-eks-cluster.version}/amazon-linux-2/recommended/release_version"
}

resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = aws_eks_cluster.my-eks-cluster.name
  node_group_name = "my-eks-cluster-workernodes"
  node_role_arn   = aws_iam_role.eks-workernode-iam-role.arn
  subnet_ids      = aws_subnet.eks-subnets[*].id 
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
  instance_types  = ["t2.micro"]

  source_security_group_ids = aws_security_group.eks-cluster-sg.id

  scaling_config {
   desired_size = var.asg-desired-size
   max_size   = var.asg-max-size
   min_size   = var.asg-min-size
  }
 
  depends_on = [
   aws_iam_role.eks-workernode-iam-role,
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
 }

resource "aws_cloudwatch_log_group" "eks_cloudwatch_logs" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.eks_log_retention
}

data "aws_ami" "eks-worker" {
   filter {
     name   = "name"
     values = ["amazon-eks-node-${aws_eks_cluster.my-eks-cluster.version}-v*"]
   }

   most_recent = true
   #owners      = ["602401143452"] # Amazon EKS AMI Account ID
 }

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We implement a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.my-eks-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster. my-eks-cluster.certificate_authority[0].data}' '${var.cluster-name}'
sudo yum update
USERDATA

}

resource "aws_launch_configuration" "eks_workernode_launch_config" {
  associate_public_ip_address = true
  #iam_instance_profile        = aws_iam_instance_profile.demo-node.name
  image_id                    = data.aws_ami.eks-worker.id
  instance_type               = "t2.micro"
  name_prefix                 = "eks-asg"
  security_groups  = [aws_security_group.eks-node-sg.id]
  user_data_base64 = base64encode(local.eks-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "eks_autoscaling_group" {
  name                 = "eks_autoscaling_group"
  vpc_zone_identifier  = [aws_subnet.eks-subnets.*.id]
  launch_configuration = aws_launch_configuration.eks_workernode_launch_config.id

  max_size             = var.asg-max-size
  min_size             = var.asg-min-size
  desired_capacity     = var.asg-desired-size

  tag {
    key                 = "Name"
    value               = "eks_autoscaling_group"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.cluster-name}"
    value               = "owned"
    propagate_at_launch = true
  }
}


