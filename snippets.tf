/* 
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
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.my-eks-cluster.endpoint}' --b64-cluster-ca '${aws_eks_cluster. my-eks-cluster.certificate_authority[0].data}' '${var.cluster_name}'
sudo yum update -y
USERDATA

}

resource "aws_launch_configuration" "eks_workernode_launch_config" {
  associate_public_ip_address = false
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
  vpc_zone_identifier  = aws_subnet.eks-subnets.*.id
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
    key                 = "kubernetes.io/cluster/${var.cluster_name}" 
	value               = "owned"
    propagate_at_launch = true
  }	
}

*/
