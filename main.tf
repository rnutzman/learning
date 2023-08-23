resource "aws_iam_role" "eks-iam-role" {
 name = "eks-iam-role"
 path = "/"

 assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
  {
   "Effect": "Allow",
   "Principal": {
    "Service": "eks.amazonaws.com"
   },
   "Action": "sts:AssumeRole"
  }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
 role       = aws_iam_role.eks-iam-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly-EKS" {
 policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
 role       = aws_iam_role.eks-iam-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-iam-role.name
}

resource "aws_eks_cluster" "my-eks-cluster" {
 name = var.cluster_name "my-eks-cluster"
 role_arn = aws_iam_role.eks-iam-role.arn

 vpc_config {
  subnet_ids = [aws_vpc.eks-vpc.subnet_id_1, var.subnet_id_2]
 }

 depends_on = [
  aws_iam_role.eks-iam-role,
 ]
}



resource "aws_iam_user" "test_svc_accts" {
  for_each = toset(var.svc_accts)

  name = each.key
}

#resource "iam-eks-role" "example" {
# my_eks_role_arn = module.iam-eks-role.iam_role_arn
#}









