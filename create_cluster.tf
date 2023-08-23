resource "aws_eks_cluster" "my-eks-cluster" {
 name = var.cluster_name 
 role_arn = aws_iam_role.eks-iam-role.arn

 vpc_config {
  subnet_ids = [aws_subnet.eks-subnet-1.id,aws_subnet.eks-subnet-2.id, aws_subnet.eks-subnet-3.id]
 }

 depends_on = [
  aws_iam_role.eks-iam-role,
 ]
}

data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.my-eks-cluster.version}/amazon-linux-2/recommended/release_version"
}

resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.my-eks-cluster.name
  node_group_name = "my-eks-cluster-workernodes"
  node_role_arn  = aws_iam_role.eks-workernode-iam-role.arn
  subnet_ids   = [aws_subnet.eks-subnet-1.id,aws_subnet.eks-subnet-2.id, aws_subnet.eks-subnet-3.id]
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
  instance_types = ["t3.micro"]
 
  scaling_config {
   desired_size = var.asg-desired-size
   max_size   = var.asg-max-size
   min_size   = var.asg-min-size
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
 }

  ]
 }
