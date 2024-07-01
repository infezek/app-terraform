resource "aws_security_group" "alb" {
  name        = "${local.namespaced_service_name}-alb"
  description = "Allow HTTP internet traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.internet_cidr_block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.internet_cidr_block
  }

  tags = {
    "Name" = "${local.namespaced_service_name}-alb"
  }
}

resource "aws_security_group" "autoscaling_group" {
  name        = "${local.namespaced_service_name}-autoscaling-group"
  description = "Allow HTTP traffic only through the load balancer"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.internet_cidr_block
    description = "Allow all traffic"
  }

  tags = {
    "Name" = "${local.namespaced_service_name}-autoscaling-group"
  }
}