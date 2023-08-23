module "iam-eks-role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-eks-role"
  #version = "5.28.0"

  role_name              = "my_eks_role"
  allow_self_assume_role = true

  #cluster_service_accounts = {
  #  "staging-main-1"   = ["default:my-app-staging"]
  #  "staging-backup-1" = ["default:my-app-staging"]
  #}
  
  tags = {
    Name = "eks-role"
  }

  role_policy_arns = {
    AmazonEKS_CNI_Policy = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  }
}

resource "aws_iam_user" "test_svc_accts" {
  for_each = toset(var.svc_accts)

  name = each.key
}

resource "iam-eks-role" "example" {
  
 my_eks_role_arn = module.iam-eks-role.iam_role_arn
}









