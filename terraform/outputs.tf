output "public_ip" {
  description = "IP público da VM"
  value       = module.vm.public_ip
}

output "vm_id" {
  description = "ID da VM criada"
  value       = module.vm.vm_id
}

output "subnet_id" {
  description = "ID da Subnet criada"
  value       = module.network.subnet_id
}
