resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "vpc_nebo"
  }
}

resource "aws_subnet" "terraform_public_subnet" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = var.subnet_public_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "terraform-public_subnet"
  }
}

resource "aws_subnet" "terraform_private_subnet" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = var.subnet_private_cidr

  tags = {
    Name = "terraform-private_subnet"
  }
}

resource "aws_internet_gateway" "terraform_nebo_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = "terraform-vnet-nebo"
  }
}

resource "aws_route_table" "terraform_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_nebo_igw.id
  }
}

resource "aws_route_table_association" "terraform_public_assoc" {
  subnet_id      = aws_subnet.terraform_public_subnet.id
  route_table_id = aws_route_table.terraform_route_table.id
}

resource "aws_iam_role" "ec2_role_ansi" {
  name = "elasticsearch_ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "ec2_policy_ansi" {
  name        = "elasticsearch_policy"
  description = "Allow EC2 to use SSM and logs"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["ssm:GetParameter", "ssm:PutParameter"],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attach_ansi" {
  role       = aws_iam_role.ec2_role_ansi.name
  policy_arn = aws_iam_policy.ec2_policy_ansi.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile_ansi" {
  name = "elasticsearch_instance_prof"
  role = aws_iam_role.ec2_role_ansi.name
}

resource "aws_security_group" "terraform_elastic_sg" {
  name        = "elastic_sg"
  description = "Allow Elasticsearch and SSH"
  vpc_id = aws_vpc.terraform_vpc.id

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "terraform_elasticsearch" {
  ami           = var.linux_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.terraform_public_subnet.id
  key_name      = "nebo_key"

  vpc_security_group_ids = [aws_security_group.terraform_elastic_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile_ansi.name

  root_block_device {
    volume_size = 20  
  }

  tags = {
    Name = "elasticsearch"
  }
}