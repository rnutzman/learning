# Need
# cluster security group - done
# workernode security group - done
# make it private - done
# set the service IP range
# Cluster addons
# ingress controller
# Autoscaling group name - done
# Configure remote access to nodes - done
# enable logging - done
# configmap


resource "aws_eks_cluster" "my-eks-cluster" {
  name     = var.cluster_name 
  role_arn = aws_iam_role.eks-cluster-iam-role.arn

  vpc_config {
    subnet_ids              = aws_subnet.eks-subnets[*].id
    security_group_ids      = ["${aws_security_group.eks-cluster-sg.id}"]
    endpoint_public_access  = false
    endpoint_private_access = true
  }

  enabled_cluster_log_types = var.control_plane_logs
  
  depends_on = [
    aws_iam_role.eks-cluster-iam-role, 
    aws_cloudwatch_log_group.eks_cloudwatch_logs,
  ]
}

resource "aws_eks_addon" "addon_vpc_cni" {
  cluster_name = aws_eks_cluster.my-eks-cluster.name
  addon_name                  = var.vpc_cni_addon[0]
  addon_version               = var.vpc_cni_addon[1]
  resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"

  timeouts {
    create = "30m"
    update = "20m"
    delete = "20m"
  }

  depends_on = [
    aws_iam_role.eks-cluster-iam-role, 
    aws_eks_cluster.my-eks-cluster, 
    aws_eks_node_group.worker-node-group]
}

resource "aws_eks_addon" "addon_core_dns" {
  cluster_name = aws_eks_cluster.my-eks-cluster.name
  addon_name                  = var.core_dns_addon[0]
  addon_version               = var.core_dns_addon[1]
  resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"

  timeouts {
    create = "30m"
    update = "20m"
    delete = "20m"
  }

  depends_on = [
    aws_iam_role.eks-cluster-iam-role, 
    aws_eks_cluster.my-eks-cluster, 
    aws_eks_node_group.worker-node-group
  ]
}

resource "aws_eks_addon" "addon_kube_proxy" {
  cluster_name = aws_eks_cluster.my-eks-cluster.name
  addon_name                  = var.kube_proxy_addon[0]
  addon_version               = var.kube_proxy_addon[1]
  resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"

  timeouts {
    create = "30m"
    update = "20m"
    delete = "20m"
  }

  depends_on = [
    aws_iam_role.eks-cluster-iam-role, 
    aws_eks_cluster.my-eks-cluster, 
    aws_eks_node_group.worker-node-group
  ]
}

resource "aws_eks_addon" "addon_csi_driver" {
  cluster_name = aws_eks_cluster.my-eks-cluster.name
  addon_name                  = var.csi_driver_addon[0]
  addon_version               = var.csi_driver_addon[1]
  resolve_conflicts_on_update = "OVERWRITE"
  resolve_conflicts_on_create = "OVERWRITE"

  timeouts {
    create = "30m"
    update = "20m"
    delete = "20m"
  }

  depends_on = [
    aws_iam_role.eks-cluster-iam-role, 
    aws_eks_cluster.my-eks-cluster, 
    aws_eks_node_group.worker-node-group
  ]
}



# EKS Node Group
data "aws_ssm_parameter" "eks_ami_release_version" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.my-eks-cluster.version}/amazon-linux-2/recommended/release_version"
}

resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = var.cluster_name
  node_group_name = "my-eks-cluster-workernodes"
  node_role_arn   = aws_iam_role.eks-workernode-iam-role.arn
  subnet_ids      = aws_subnet.eks-subnets[*].id 
  release_version = nonsensitive(data.aws_ssm_parameter.eks_ami_release_version.value)
  instance_types  = ["t2.micro"]

  remote_access {
    ec2_ssh_key = var.ec2_ssh_key
    source_security_group_ids = [aws_security_group.eks-node-sg.id]
  }

  scaling_config {
    desired_size = var.asg-desired-size
    max_size   = var.asg-max-size
    min_size   = var.asg-min-size
  }
 
  depends_on = [
    aws_iam_role.eks-workernode-iam-role,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    #aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_cloudwatch_log_group" "eks_cloudwatch_logs" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.eks_log_retention
}


