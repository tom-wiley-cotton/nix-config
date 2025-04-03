# Create profiles using the profiles module
module "profiles" {
  source = "../../../modules/profiles"

  environment    = "dev"
  network_bridge = var.network_bridge
  storage_pool   = var.storage_pool
  vm_config      = var.vm_config
  storage_sizes  = var.storage_sizes
  base_config    = var.base_config
}