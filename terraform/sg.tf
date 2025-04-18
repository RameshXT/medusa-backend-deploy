# ALB SG
resource "aws_security_group" "medusa_sg" {
  name        = "medusa-public-sg"
  description = "Allow HTTP, HTTPS, and SSH"
  vpc_id      = aws_vpc.medusa_vpc.id
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "medusa-public-sg"
  }
}

# ECS SG 
resource "aws_security_group" "medusa_ecs_sg" {
  name        = "medusa-ecs-sg"
  description = "Security Group for ECS Service"
  vpc_id      = aws_vpc.medusa_vpc.id

  ingress {
    description     = "Allow Container to ALB"
    from_port       = 9000
    to_port         = 9000
    protocol        = "tcp"
    security_groups = [aws_security_group.medusa_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "medusa-ecs-sg"
  }
}

# RDS SG
resource "aws_security_group" "rds_sg" {
  name        = "medusa-rds-sg"
  description = "Allow Postgres inbound"
  vpc_id      = aws_vpc.medusa_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.medusa_ecs_sg.id]
    description     = "Allow ECS to connect to RDS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}
