output "eks_cluster_role_arn" {
  description = "ARN for the eks cluster role"
  value = aws_iam_role.eks-cluster-iam-role.arn
}

output "eks_workernode_role_arn" {
  description = "ARN for the eks workernode role"
  value = aws_iam_role.eks-workernode-iam-role.arn
}

#output "user_arns" {
#  description = "ARNs for created users"
#  value = [ for accts in aws_iam_user.test_svc_accts: accts.arn]
#}


