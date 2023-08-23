resource "aws_eks_cluster" "my-eks-cluster" {
 name = var.cluster_name "my-eks-cluster"
 role_arn = aws_iam_role.eks-iam-role.arn

 vpc_config {
  subnet_ids = [aws_subnet.eks-subnet-1.id,aws_subnet.eks-subnet-2.id, aws_subnet.eks-subnet-3.id]
 }

 depends_on = [
  aws_iam_role.eks-iam-role,
 ]
}

resource "aws_eks_node_group" "worker-node-group" {
  cluster_name  = aws_eks_cluster.my-eks-cluster.name
  node_group_name = "my-eks-cluster-workernodes"
  node_role_arn  = aws_iam_role.workernodes.arn
  subnet_ids   = [var.subnet_id_1, var.subnet_id_2]
  instance_types = ["t3.micro"]
 
  scaling_config {
   desired_size = 1
   max_size   = 1
   min_size   = 1
  }
 
  depends_on = [
   aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
   aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
   #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
 }

  ]
 }
