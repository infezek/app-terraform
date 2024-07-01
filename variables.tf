variable "aws_region" {
  type        = string
  description = "AWS region where the resources will be deployed."
  default     = "us-east-2"
}

variable "environment" {
  type        = string
  description = "Name of the deployment environment (e.g., dev, stage, prod)."
  default     = "dev"
}

variable "service_name" {
  type        = string
  description = "Name of the service/application to be deployed."
  default     = "app-go"
}

variable "instance_config" {
  description = "Configuration for the EC2 instances."
  type = object({
    ami      = string
    type     = string
    key_name = optional(string, null)
  })
  default = {
    ami  = "ami-09040d770ffe2224f"
    type = "t2.medium"
  }
}

variable "alb_health_check_config" {
  description = "Configuration for the Application Load Balancer (ALB) health checks."
  nullable    = true
  default     = {}
  type = object({
    enabled             = optional(bool, true)
    healthy_threshold   = optional(number, 3)
    interval            = optional(number, 30)
    matcher             = optional(string, "200")
    path                = optional(string, "/healthz")
    port                = optional(number, 80)
    protocol            = optional(string, "HTTP")
    timeout             = optional(number, 5)
    unhealthy_threshold = optional(number, 3)
  })
}

variable "autoscaling_group_config" {
  description = "Configuration for the Auto Scaling group."
  default     = {}
  type = object({
    desired_capacity          = optional(number, 2)
    min_size                  = optional(number, 1)
    max_size                  = optional(number, 5)
    health_check_grace_period = optional(number, 320) // Grace period for health checks (seconds).
    health_check_type         = optional(string, "ELB")
    force_delete              = optional(bool, false)
  })
}

variable "autoscaling_policy_cpu" {
  description = "Configuration for the CPU utilization auto scaling policy."
  nullable    = true
  default     = {}
  type = object({
    enabled          = optional(bool, true)
    name             = optional(string, "CPU utilization")
    disable_scale_in = optional(bool, false)
    target_value     = optional(number, 40)
  })
}

variable "autoscaling_policy_alb" {
  description = "Configuration for the ALB request rate auto scaling policy."
  nullable    = true
  default     = {}
  type = object({
    enabled          = optional(bool, true)
    name             = optional(string, "Load balancer request per minute")
    disable_scale_in = optional(bool, false)
    target_value     = optional(number, 40)
  })
}