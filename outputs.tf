output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.eks-vpc.id
}

output "subnet_ids" {
  description = "Subnet details"
  #value = aws_subnet.eks-subnets[*].id
  #value = keys({for subnet in aws_subnet.eks-subnets: subnet.id => subnet.cidr_block => subnet.availability_zone})
  value = aws_subnet.eks-subnets
}

output "eks_cluster_role_arn" {
  description = "ARN for the eks cluster role"
  value = aws_iam_role.eks-cluster-iam-role.arn
}

output "eks_workernode_role_arn" {
  description = "ARN for the eks workernode role"
  value = aws_iam_role.eks-workernode-iam-role.arn
}

output "cluster_sg" {
  description = "Cluster Security Group"
  value = "Cluster Security Group: ${eks-cluster-sg}"
}

output "node_sg" {
  description = "Node Security Group"
  value = "Node Security Group: ${eks-node-sg}"
}

output "asg_name" {
  value = aws_autoscaling_group.eks_autoscaling_group.name
}

output "cluster_name" {
  value = aws_eks_cluster.my-eks-cluster.name
}




