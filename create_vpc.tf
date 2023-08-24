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
