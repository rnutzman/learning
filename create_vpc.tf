resource "aws_vpc" "eks-vpc" {
  assign_generated_ipv6_cidr_block = false
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = {
    Name    = "EKS-VPC"
    POC     = "Ron"
    Project = "Learning"
  }
}

resource "aws_subnet" "eks-subnets" {
  count      = var.aws_subnet_cnt

  vpc_id                  = aws_vpc.eks-vpc.id
  cidr_block              = lookup(var.aws_subnet_cidr, var.aws_subnets[count.index])
  availability_zone_id    = lookup(var.aws_subnet_az, var.aws_subnets[count.index])
  map_public_ip_on_launch = false
  enable_dns_hostnames    = false
  enable_dns_support      = true

  tags = {
    Name                            = var.aws_subnets[count.index]
    VPC                             = aws_vpc.eks-vpc.id
    AZ                              = lookup(var.aws_subnet_az, var.aws_subnets[count.index])
    kubernetes.io/role/internal-elb = 1
  }
}

resource "aws_vpc" "VPC" {
  count                            = var.mycount
  assign_generated_ipv6_cidr_block = false
  cidr_block                       = lookup(var.aws_subnet_cidr, var.aws_subnets[count.index])
  enable_dns_hostnames             = false
  enable_dns_support               = true
  instance_tenancy                 = "default"
  tags = {
    "Name" = var.aws_subnets[count.index]
  }
}

resource "aws_subnet" "eks-subnet-1" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "10.0.1.0/24"

  map_public_ip_on_launch = false
  availability_zone_id    = "use2-az1"
  
  tags = {
    Name = "eks-subnet-1"
    VPC  = aws_vpc.eks-vpc.id
    AZ   = "us-east-2a"
  }
}

resource "aws_subnet" "eks-subnet-2" {
  vpc_id      = aws_vpc.eks-vpc.id
  cidr_block  = "10.0.2.0/24"
  
  map_public_ip_on_launch = false
  availability_zone_id    = "use2-az2"
  
  tags = {
    Name = "eks-subnet-2"
    VPC  = aws_vpc.eks-vpc.id
    AZ   = "us-east-2b"
  }
}

resource "aws_subnet" "eks-subnet-3" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "10.0.3.0/24"
   
  map_public_ip_on_launch = false
  availability_zone_id    = "use2-az3"
  
  tags = {
    Name = "eks-subnet-3"
    VPC  = aws_vpc.eks-vpc.id
    AZ   = "us-east-2c"
  }
}
