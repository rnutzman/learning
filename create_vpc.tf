resource "aws_vpc" "eks-vpc" {
  assign_generated_ipv6_cidr_block = false
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = {
    Name                                        = "EKS-VPC"
    POC                                         = "Ron"
    Project                                     = "Learning"
	"kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_subnet" "eks-subnets" {
  count      = var.aws_subnet_cnt

  vpc_id                  = aws_vpc.eks-vpc.id
  cidr_block              = lookup(var.aws_subnet_cidr, var.aws_subnets[count.index])
  #availability_zone_id    = lookup(var.aws_subnet_az, var.aws_subnets[count.index])
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch = false

  tags = {
    "Name"                                      = var.aws_subnets[count.index]
    "VPC"                                       = aws_vpc.eks-vpc.id
    #"AZ"                                        = lookup(var.aws_subnet_az, var.aws_subnets[count.index])
    "AZ"                                        = data.aws_availability_zones.available.names[count.index]
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}















