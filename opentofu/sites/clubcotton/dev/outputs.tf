output "homeassistant_ip" {
  description = "IP address of the Home Assistant instance"
  value       = module.instances.homeassistant_ipv4
}

output "homeassistant_macvlan_ip" {
  description = "IP address of the Home Assistant macvlan instance"
  value       = var.enable_test_instances ? module.instances.homeassistant_macvlan_ipv4 : null
}

output "test_container_ip" {
  description = "IP address of the test container"
  value       = var.enable_test_instances ? module.instances.test_container_ipv4 : null
}

output "profiles" {
  description = "List of created profiles"
  value = {
    base      = module.profiles.base_profile_name
    vm        = module.profiles.vm_profile_name
    container = module.profiles.container_profile_name
    haos      = module.profiles.haos_profile_name
    haos_macvlan = module.profiles.haos_macvlan_profile_name
  }
}