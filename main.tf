module "iam-eks-role" {
  source  = "terraform-aws-modules/iam/aws//examples/iam-eks-role"
  version = "5.28.0"
}

resource "aws_iam_user" "test_svc_accts" {
  for_each = toset(var.svc_accts)

  name = each.key
}











