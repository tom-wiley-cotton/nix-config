# Create profiles using the profiles module
module "profiles" {
  source = "../../../modules/profiles"

  environment      = "dev"
  network_bridge   = var.network_bridge
  host_interface   = var.host_interface
  storage_pool     = var.storage_pool
  vm_config        = var.vm_config
  container_config = var.container_config
  storage_sizes    = var.storage_sizes
  base_config      = var.base_config
}

# Create instances using the instances module
module "instances" {
  source = "../../../modules/instances"

  environment            = "dev"
  network_bridge        = var.network_bridge
  host_interface        = var.host_interface
  storage_pool         = var.storage_pool
  storage_sizes        = var.storage_sizes
  container_profile    = module.profiles.container_profile_name
  haos_profile        = module.profiles.haos_profile_name
  haos_macvlan_profile = module.profiles.haos_macvlan_profile_name
  enable_test_instances = var.enable_test_instances

  depends_on = [
    module.profiles
  ]
}