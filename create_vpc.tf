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

resource "aws_subnet" "eks-subnets" {
  count      = var.aws_subnet_cnt

  vpc_id                  = aws_vpc.eks-vpc.id
  cidr_block              = lookup(var.aws_subnet_cidr, var.aws_subnets[count.index])
  availability_zone_id    = lookup(var.aws_subnet_az, var.aws_subnets[count.index])
  map_public_ip_on_launch = false

  tags = concat(
    [
      {
        "key"                 = "Name"
        "value"               = "${var.aws_subnets[count.index]}"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "VPC"
        "value"               = "${aws_vpc.eks-vpc.id}"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "AZ"
        "value"               = $"{lookup(var.aws_subnet_az, var.aws_subnets[count.index])}"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "kubernetes.io/role/internal-elb"
        "value"               = "1"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "kubernetes.io/cluster/${var.cluster_name}"
        "value"               = "shared"
        "propagate_at_launch" = true
      },
    ],
	var.default_tags,
  )
}














