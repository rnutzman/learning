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

s
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

resource "aws_eks_addon" "my-eks-cluster" {
  cluster_name = aws_eks_cluster.my-eks-cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "my-eks-cluster" {
  cluster_name = aws_eks_cluster.my-eks-cluster.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "my-eks-cluster" {
  cluster_name = aws_eks_cluster.my-eks-cluster.name
  addon_name   = "kube-proxy"
}

# EKS Node Group
data "aws_ssm_parameter" "eks_ami_release_version" {
  description = "Get eks optimized ami"
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.my-eks-cluster.version}/amazon-linux-2/recommended/release_version"
}

resource "aws_ks_node_group" "worker-node-group" {
  cluster_name    = var.cluster_name
  node_group_name = "my-eks-cluster-workernodes"
  node_role_arn   = aws_iam_role.eks-workernode-iam-role.arn
  subnet_ids      = aws_subnet.eks-subnets[*].id 
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
  instance_types  = ["t2.micro"]

  remote_access {
    source_security_group_ids = aws_security_group.eks-cluster-sg.id
  }

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


