resource "aws_alb" "this" {
  name               = local.namespaced_service_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = local.public_subnet_ids

  tags = {
    "Name" = local.namespaced_service_name
  }
}


resource "aws_alb_target_group" "http" {
  name     = local.namespaced_service_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id

  health_check {
    enabled             = var.alb_health_check_config.enabled
    port                = var.alb_health_check_config.port
    timeout             = var.alb_health_check_config.timeout
    protocol            = var.alb_health_check_config.protocol
    interval            = var.alb_health_check_config.interval
    matcher             = var.alb_health_check_config.matcher
    path                = var.alb_health_check_config.path
    unhealthy_threshold = var.alb_health_check_config.unhealthy_threshold
    healthy_threshold   = var.alb_health_check_config.healthy_threshold
  }
}


resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.http.arn
  }
}