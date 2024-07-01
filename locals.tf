locals {
  namespaced_service_name = "${var.service_name}-${var.environment}"

  subnets = {
    "public_a" = {
      cidr_block = "10.0.0.0/20"
      az         = "a"
      name       = "public-a"
    }
    "public_b" = {
      cidr_block = "10.0.16.0/20"
      az         = "b"
      name       = "public-b"
    }
    "public_c" = {
      cidr_block = "10.0.32.0/20"
      az         = "c"
      name       = "public-c"
    }
  }

  subnet_ids = {
    for k, v in aws_subnet.this : v.tags.Name => v.id
  }

  internet_cidr_block = ["0.0.0.0/0"]

  public_subnet_ids = [
    aws_subnet.this["public_a"].id,
    aws_subnet.this["public_b"].id,
    aws_subnet.this["public_c"].id,
  ]
}
