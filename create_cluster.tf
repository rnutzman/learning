# Need
# cluster security group
# workernode security group
# make it private
# set the service IP range
# Cluster addons
# ingress controller
# Autoscaling group name
# Configure remote access to nodes
# enable logging - done
# configmap


resource "aws_eks_cluster" "my-eks-cluster" {
  name = var.cluster_name 
  role_arn = aws_iam_role.eks-cluster-iam-role.arn

  vpc_config {
    subnet_ids              = aws_subnet.eks-subnets[*].id
	#security_group_ids     = 
	endpoint_public_access  = false
	endpoint private_access = true
  }
  
  enabled_cluster_log_types = [var.control_plane_logs]
  
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