variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-2"
}

# VPC Variablesstring
variable "aws_subnet_cnt" {
  description = "Number of subnets to create (1 to 3)"
  default     = 2
}

variable "aws_subnets" {
  description = "Subnet names"
  type        = list
  default     = ["eks-subnet-1", "eks-subnet-2", "eks-subnet-3"]
}

variable "aws_subnet_cidr" {
  description = "Subnet cidr blocks"
  # probably want to make this more dynamic
  default = {
    "eks-subnet-1" = "10.0.1.0/24"
    "eks-subnet-2" = "10.0.2.0/24"
    "eks-subnet-3" = "10.0.3.0/24"
  }
}

variable "aws_subnet_az" {
  description = "List of availability zones to use"
  default = {
    "eks-subnet-1" = "use2-az1"
    "eks-subnet-2" = "use2-az2"
    "eks-subnet-3" = "use2-az3"
  }
}


# EKS cluster variables
variable "cluster_name" {
  description = "Cluster Name"
  default     = "my-eks-cluster"
}

variable "control_plane_logs" {
  description = "EKS control plane logs (api, audit, authenticator, controllerManager, and/or scheduler) to send to cloudwatch"
  type        = list
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

variable "asg-desired-size" {
  description = "AWS Autoscaling Group - Desired Size"
  default     = 1
}

variable "asg-max-size" {
  description = "AWS Autoscaling Group - Maximum Size"
  default     = 1
}

variable "asg-min-size" {
  description = "AWS Autoscaling Group - Minimum Size"
  default     = 1
}

variable "eks_log_retention" {
  description = "How long to store eks logs in cloudwatch"
  default     = 3
}


# Cluster Addon Variables
variable "csi_driver_addon" {
  description = "csi_driver_addon with version"
  type = object({
    name     = string
    version  = string
    role-arn = string
  })
  default = {
    name     = "aws-ebs-csi-driver"
    version  = ""
    role-arn = ""
  }
}

variable "core_dns_addon" {
  description = "core_dns addon with version"
  type = object({
    name     = string
    version  = string
  })
  default = {
    name     = "coredns"
    version  = ""
  }
}

variable "kube_proxy_addon" {
  description = "kube-proxy addon with version"
  type = object({
    name     = string
    version  = number
  })
  default = {
    name     = "kube-proxy"
    version  = -1
  }
}

variable "vpc_cni_addon" {
  description = "vpc-cni addon with version"
  type = object({
    name     = string
    version  = number
  })
  default = {
    name     = "vpc-cni"
    version  = -1
  }
}




variable "default_tags" {
  default = {
    "POC"         = "RNutzman"
    "Environment" = "DEV"
  }
}

variable "ec2_ssh_key" {
  description = "SSH Key to remote access nodes"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCuOzwvOoiIfsJd3XFUQjehR5LpSepgV04qEItNkMWuuxC68uS6x7DbG8uRH5/eZbpTMdvsWYML3Xu7ue0JD0lUhV1jmYfp1MfYaWsVV/8+S/CtaESk6H9jaTD1m9yDvgalc5w2T6Y5bG2LzOHVaEwYpSnMcjIciVMw7odEKncqXQ7OOqdufv0AlqUoH3IlwZHh1A6tC3jMXuicLkhrPIjgTGmPWns1c9osLGFTmZqa/pOIUUpoPZAV0JljHqZPNqcgpAh8o0xa3+pzGG0N2GwKoynZBjaAOtEopt7o3GbC0OeI/ch7fBZ/pxeXAzAUFGOSyz7NvCrp1cjLCyENJc1Ow+RB+gwGyUvVj8SAk3lvkiDBcDiR2JfguCQjghjSyfw2OsDrXtTotJstAEt1ZB/0++lWctXgL9BllBr6G5wUXhoGBug5llinrdA0VlohEaVvT92wc4T5GC2Je8hHBR5Q7baq593/swbNuWKocU0kCBLbxyyFrm1f52zHY/YCde8= ron.nutzman_cn@CMW-7LFZBV3.cacicorenet.com"
}
