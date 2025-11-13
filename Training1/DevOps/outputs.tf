output "devops_vpc_id" {
  description = "DevOps VPC id"
  value       = module.devops_vpc.vpc_id
}

output "devops_vm_id" {
  value = aws_instance.devops_vm.id
}

output "devops_vm_private_ip" {
  value = aws_instance.devops_vm.private_ip
}

