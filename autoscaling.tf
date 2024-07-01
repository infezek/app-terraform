resource "aws_autoscaling_group" "this" {
  name                      = local.namespaced_service_name
  desired_capacity          = var.autoscaling_group_config.desired_capacity
  min_size                  = var.autoscaling_group_config.min_size
  max_size                  = var.autoscaling_group_config.max_size
  health_check_grace_period = var.autoscaling_group_config.health_check_grace_period
  health_check_type         = var.autoscaling_group_config.health_check_type
  force_delete              = var.autoscaling_group_config.force_delete

  target_group_arns   = [aws_alb_target_group.http.id]
  vpc_zone_identifier = local.public_subnet_ids

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }
}

resource "aws_autoscaling_policy" "rpm_policy" {
  name                   = var.autoscaling_policy_alb.name
  enabled                = var.autoscaling_policy_alb.enabled
  autoscaling_group_name = aws_autoscaling_group.this.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    disable_scale_in = var.autoscaling_policy_alb.disable_scale_in
    target_value     = var.autoscaling_policy_alb.target_value
    predefined_metric_specification {
      predefined_metric_type = "ALBRequestCountPerTarget"
      resource_label         = "${aws_alb.this.arn_suffix}/${aws_alb_target_group.http.arn_suffix}"
    }
  }
}

resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = var.autoscaling_policy_cpu.name
  enabled                = var.autoscaling_policy_cpu.enabled
  autoscaling_group_name = aws_autoscaling_group.this.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    disable_scale_in = var.autoscaling_policy_cpu.disable_scale_in
    target_value     = var.autoscaling_policy_cpu.target_value
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
}