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
  name     = var.cluster_name 
  role_arn = aws_iam_role.eks-cluster-iam-role.arn

  vpc_config {
    subnet_ids              = aws_subnet.eks-subnets[*].id
    security_group_ids      = ["${aws_security_group.eks-cluster-sg.id}"]
    endpoint_public_access  = false
    endpoint_private_access = true
  }

  enabled_cluster_log_types = var.control_plane_logs
  
  depends_on = [
    aws_iam_role.eks-cluster-iam-role, 
    aws_cloudwatch_log_group.eks_cloudwatch_logs,
  ]
}

resource "aws_eks_addon" "load_addons" {
  count = var.addon-cnt
  
  cluster_name = aws_eks_cluster.my-eks-cluster.name
  
  addon_name                  = var.addon[count.index].name
  addon_version               = var.addon[count.index].version
  service_account_role_arn    = var.addon[count.index].role-arn
  resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"

  timeouts {
    create = var.addon[count.index].create-timeout
    update = var.addon[count.index].update-timeout
    delete = var.addon[count.index].delete-timeout
  }
  
  tags = {
    "Name"        = var.addon[count.index].name
    "EKS Cluster" = aws_eks_cluster.my-eks-cluster.name
  }	
  
  depends_on = [
    aws_eks_cluster.my-eks-cluster,
	aws_iam_role.eks-cluster-iam-role, 
    aws_eks_cluster.my-eks-cluster 
    #aws_eks_node_group.worker-node-group
  ]
}


/*
# EKS Node Group
resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = var.cluster_name
  node_group_name = "my-eks-cluster-workernodes"
  node_role_arn   = aws_iam_role.eks-workernode-iam-role.arn
  subnet_ids      = aws_subnet.eks-subnets[*].id 

  ami_type        = var.nodes.ami-type
  instance_types  = [var.nodes.instance-type]
  capacity_type   = var.nodes.capacity-type
  disk_size       = var.nodes.disk-size

  #remote_access {
  #  ec2_ssh_key               = var.ec2_ssh_key
  #  source_security_group_ids = [aws_security_group.eks-node-sg.id]
  #}

  scaling_config {
    desired_size = var.asg-desired-size
    max_size     = var.asg-max-size
    min_size     = var.asg-min-size
  }
 
  update_config {
    max_unavailable = 1
  }

  tags = {
    "Name"        = var.addon[count.index].name
    "EKS Cluster" = aws_eks_cluster.my-eks-cluster.name
  }

  depends_on = [
    aws_eks_cluster.my-eks-cluster,
    aws_iam_role.eks-workernode-iam-role,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
*/

resource "aws_cloudwatch_log_group" "eks_cloudwatch_logs" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.eks_log_retention
}


