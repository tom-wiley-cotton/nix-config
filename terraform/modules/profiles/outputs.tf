output "base_profile_name" {
  description = "Name of the base profile"
  value       = incus_profile.base.name
}

output "vm_profile_name" {
  description = "Name of the VM profile"
  value       = incus_profile.vm.name
}

output "container_profile_name" {
  description = "Name of the container profile"
  value       = incus_profile.container.name
}

output "haos_profile_name" {
  description = "Name of the Home Assistant OS profile"
  value       = incus_profile.haos.name
}

output "haos_macvlan_profile_name" {
  description = "Name of the Home Assistant OS macvlan profile"
  value       = incus_profile.haos_macvlan.name
}