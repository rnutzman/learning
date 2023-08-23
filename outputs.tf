#output "role_arn" {
#  value = iam-eks-role.iam_role_arn
#}

output "user_arns" {
  value = [ for accts in aws_iam_user.test_svc_accts: accts.arn]
}


