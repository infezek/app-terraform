resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = local.namespaced_service_name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    "Name" = local.namespaced_service_name
  }
}


resource "aws_subnet" "this" {
  for_each          = local.subnets
  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr_block
  availability_zone = "${var.aws_region}${each.value.az}"
  tags = {
    "Name" = "${local.namespaced_service_name}-${each.value.name}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    "Name" = "${local.namespaced_service_name}-public"
  }
}

resource "aws_route_table_association" "this" {
  for_each = local.subnet_ids

  route_table_id = aws_route_table.public.id
  subnet_id      = each.value
}

