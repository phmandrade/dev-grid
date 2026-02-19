variable "resource_group_name" {
  description = "Nome do Resource Group"
  default     = "truck-rg"
}

variable "location" {
  description = "Região do Azure"
  default     = "eastus"
}

variable "ssh_ip" {
  description = "IP local autorizado para SSH"
}

variable "admin_username" {
  description = "Usuário administrador da VM"
  default     = "azureuser"
}

variable "ssh_key" {
  description = "Chave pública SSH para acesso"
}
