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
