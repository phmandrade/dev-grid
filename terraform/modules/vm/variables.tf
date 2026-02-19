variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "subnet_id" {
  description = "ID of the Subnet"
  type        = string
}

variable "nsg_id" {
  description = "ID of the Network Security Group"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "ssh_key" {
  description = "SSH public key for authentication"
  type        = string
}
