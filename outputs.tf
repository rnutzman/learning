output "role_arn" {
  description = "ARN for the eks role"
  #value = iam-eks-role.iam_role_arn
  value = example_resource.example.my_eks_role_arn
}

output "user_arns" {
  description = "ARNs for created users"
  value = [ for accts in aws_iam_user.test_svc_accts: accts.arn]
}


