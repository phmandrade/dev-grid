variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "ssh_ip" {
  description = "Local IP address allowed for SSH access"
  type        = string
}
