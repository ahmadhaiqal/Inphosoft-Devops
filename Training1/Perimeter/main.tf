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

# Create Perimeter VPC
module "vpc" {
  source = "../Modules/vpc"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  tag = var.azs
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

# Create public subnets
module "public_subnets" {
  source = "../Modules/subnet"
  for_each = {
    for idx, cidr in var.public_subnets : idx => {
      cidr_block        = cidr
      availability_zone = var.azs[idx]
      name              = "${var.vpc_name}-public-${idx + 1}"
    }
  }

  name              = each.value.name
  vpc_id            = module.vpc.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  public            = true
}

# NAT Gateway (in first public subnet)
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(module.public_subnets)[0].subnet_id
  tags = {
    Name = "${var.vpc_name}-natgw"
  }
  depends_on = [aws_internet_gateway.this]
}

# Create private subnets
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
  vpc_id            = module.vpc.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  public            = false
}
