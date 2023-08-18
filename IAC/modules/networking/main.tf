resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

}

resource "aws_subnet" "public" {
  count      = length(var.pub_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.pub_cidrs[count.index]
  availability_zone = data.aws_availability_zones.az.names[count.index]

  tags = {
    "Name" = "Public-${count.index + 1}" 
  }
}

# Create Internet Gateway

resource "aws_internet_gateway" "main" {
      vpc_id = aws_vpc.main.id
  
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  

  tags = {
    Name = "public-router"
  }
}

# Associate route table with public subnets

resource "aws_route_table_association" "public" {

  count      = length(var.pub_cidrs)
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.id
}


resource "aws_default_security_group" "default-sg" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}