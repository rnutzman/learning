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

variable "svc_accts" {
  type        = list(string)
  description = "Service accounts"
  default     = ["ron.nutzman","sherrie.nutzman"]
}