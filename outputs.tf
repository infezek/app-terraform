output "vpc_id" {
  value       = aws_vpc.this.id
  description = "The ID of the Virtual Private Cloud (VPC)."
}

output "igw_id" {
  value       = aws_internet_gateway.this.id
  description = "The ID of the Internet Gateway (IGW) associated with the VPC."
}

output "subnet_ids" {
  value       = local.subnet_ids
  description = "A map associating subnet names to their respective IDs."
}

output "route_table_public_id" {
  value       = aws_route_table.public.id
  description = "The ID of the public route table."
}

output "alb_id" {
  value       = aws_alb.this.id
  description = "The ID of the Application Load Balancer (ALB)."
}

output "alb_dns" {
  value       = aws_alb.this.dns_name
  description = "The DNS name of the Application Load Balancer (ALB)."
}
