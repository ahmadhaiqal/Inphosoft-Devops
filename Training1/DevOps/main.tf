terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "devops_vpc" {
  source   = "../Modules/vpc"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  tag      = var.azs
}

# DevOps Private Subnets (NO Public)
module "private_subnets" {
  source = "../Modules/subnet"

  for_each = {
    for idx, cidr in var.private_subnets : idx => {
      cidr_block        = cidr
      availability_zone = var.azs[idx]
      name              = "${var.vpc_name}-private-${idx + 1}"
    }
  }

  name              = each.value.name
  vpc_id            = module.devops_vpc.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  public            = false
}

# VPC Peering to Perimeter
resource "aws_vpc_peering_connection" "devops_to_perimeter" {
  vpc_id      = module.devops_vpc.vpc_id
  peer_vpc_id = var.perimeter_vpc_id
  auto_accept = true

  tags = {
    Name = "devops-to-perimeter"
  }
}

# Update DevOps route tables for east-west traffic
# Every DevOps subnet needs a route → Perimeter
resource "aws_route" "devops_to_perimeter" {
  for_each = module.private_subnets

  route_table_id            = each.value.route_table_id
  destination_cidr_block    = var.perimeter_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.devops_to_perimeter.id
}

# SSM Interface Endpoints (Private)
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = module.devops_vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [for s in module.private_subnets : s.subnet_id]
  security_group_ids  = []
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = module.devops_vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [for s in module.private_subnets : s.subnet_id]
  private_dns_enabled = true
  security_group_ids  = []
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = module.devops_vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [for s in module.private_subnets : s.subnet_id]
  private_dns_enabled = true
  security_group_ids  = []
}

# S3 Gateway Endpoint (required for SSM agent)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.devops_vpc.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [for s in module.private_subnets : s.route_table_id]
}

