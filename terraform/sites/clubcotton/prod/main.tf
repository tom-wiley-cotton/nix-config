# Create profiles using the profiles module
module "profiles" {
  source = "../../../modules/profiles"

  environment      = "prod"
  network_bridge   = var.network_bridge
  host_interface   = var.host_interface
  storage_pool     = var.storage_pool
  vm_config        = var.vm_config
  container_config = var.container_config
  storage_sizes    = var.storage_sizes
  base_config      = var.base_config
}