module "network" {
  source              = "./modules/network"
  vnet_name           = "truck-vnet"
  subnet_name         = "truck-subnet"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "security" {
  source              = "./modules/security"
  resource_group_name = var.resource_group_name
  location            = var.location
  ssh_ip              = var.ssh_ip
}

module "vm" {
  source              = "./modules/vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = module.network.subnet_id
  nsg_id              = module.security.nsg_id
  admin_username      = var.admin_username
  ssh_key             = var.ssh_key
}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    public_ip     = module.vm.public_ip
    admin_username = var.admin_username
  })
  filename = "${path.module}/../ansible/hosts.ini"
}
