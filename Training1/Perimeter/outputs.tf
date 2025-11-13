output "perimeter_vpc_id" {
  description = "Perimeter VPC id"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  value = [for s in module.public_subnets : s.subnet_id]
}

output "private_subnets" {
  value = [for s in module.private_subnets : s.subnet_id]
}

output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}
