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
  default = ["vpc-10-1", "vpc-10-2"]
}

variable "aws_cidr" {
  default = {
    "vpc-10-1"       = "10.0.1.0/16"
    "vpc-devt-proja" = "10.3.0.0/16"
    "vpc-10-2"       = "10.2.0.0/16"
    "vpc-devt-projx" = "10.4.0.0/16"
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
