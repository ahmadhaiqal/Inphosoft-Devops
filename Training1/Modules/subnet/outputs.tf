output "subnet_id" {
  value = aws_subnet.this.id
}

output "subnet_az" {
  description = "Availability zone of the subnet"
  value       = aws_subnet.this.availability_zone
}

output "subnet_cidr" {
  description = "CIDR block of the subnet"
  value       = aws_subnet.this.cidr_block
}

# expose nested module outputs (route table & nacl) for consumers
output "route_table_id" {
  description = "Route table ID associated with this subnet (from nested module)"
  value       = module.route_table.route_table_id
}

output "network_acl_id" {
  description = "Network ACL ID associated with this subnet (from nested module)"
  value       = module.nacl.network_acl_id
}
