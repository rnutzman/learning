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

variable "asg.desired-size" {
  description = "AWS Autoscaling Group - Desired Size"
  default     = "1"
}

variable "asg.max-size" {
  description = "AWS Autoscaling Group - Maximum Size"
  default     = "1"
}

variable "asg.min-size" {
  description = "AWS Autoscaling Group - Minimum Size"
  default     = "1"
}




#variable "svc_accts" {
#  type        = list(string)
#  description = "Service accounts"
#  default     = ["ron.nutzman","sherrie.nutzman"]
#}
