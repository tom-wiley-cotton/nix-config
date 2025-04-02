output "homeassistant_ip" {
  description = "IP address of the Home Assistant instance"
  value       = module.instances.homeassistant_ipv4
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