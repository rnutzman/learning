variable "vpc_id" {
  description = "VPC ID"
  default     = "vpc-38f7e550"
}

variable "subnet_id" {
  description = "Subnet ID"
  default     = "subnet-adb58fc5"
}

variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-2"
}

# VPC Variables
variable "aws_subnets" {
  type    = list
  default = ["eks-subnet-1", "eks-subnet-2", "eks-subnet-3"]
}

variable "aws_subnet_cidr" {
  default = {
    "eks-subnet-1" = "10.0.1.0/24"
    "eks-subnet-2" = "10.0.2.0/24"
    "eks-subnet-3" = "10.0.3.0/24"
  }
}

variable "aws_subnet_az" {
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

variable "asg-desired-size" {
  description = "AWS Autoscaling Group - Desired Size"
  default     = "1"
}

variable "asg-max-size" {
  description = "AWS Autoscaling Group - Maximum Size"
  default     = "1"
}

variable "asg-min-size" {
  description = "AWS Autoscaling Group - Minimum Size"
  default     = "1"
}




#variable "svc_accts" {
#  type        = list(string)
#  description = "Service accounts"
#  default     = ["ron.nutzman","sherrie.nutzman"]
#}
