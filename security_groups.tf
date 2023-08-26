#Security groups

resource "aws_security_group" "eks-cluster-sg" {
  name        = "eks-cluster-sg"
  description = "Cluster security group"
  vpc_id      = aws_vpc.eks-vpc.id

  egress {
    description = "Cluster communication with worker nodes"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster-sg"
  }
}

resource "aws_security_group" "eks-node-sg" {
  name        = "eks-node-sg"
  description = "Node security group"
  vpc_id      = aws_vpc.eks-vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.eks-vpc.cidr_block]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                      = "eks-node-sg"
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
  }
}


resource "aws_security_group_rule" "demo-node-ingress-self" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks-node-sg.id
  source_security_group_id = aws_security_group.eks-node-sg.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-node-sg.id
  source_security_group_id = aws_security_group.eks-cluster-sg.id
  to_port                  = 65535
  type                     = "ingress"
 }

resource "aws_security_group_rule" "cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-cluster-sg.id
  source_security_group_id = aws_security_group.eks-node-sg.id
  to_port                  = 443
  type                     = "ingress"
}


