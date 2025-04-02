output "homeassistant_ip" {
  description = "IP address of the Home Assistant instance"
  value       = incus_instance.homeassistant.ipv4_address
}

output "homeassistant_macvlan_ip" {
  description = "IP address of the Home Assistant macvlan instance"
  value       = var.enable_test_instances ? incus_instance.homeassistant_macvlan[0].ipv4_address : null
}

output "test_container_ip" {
  description = "IP address of the test container"
  value       = var.enable_test_instances ? incus_instance.test_container[0].ipv4_address : null
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