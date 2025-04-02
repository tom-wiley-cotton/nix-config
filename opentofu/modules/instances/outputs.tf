output "homeassistant_name" {
  description = "Name of the Home Assistant instance"
  value       = incus_instance.homeassistant.name
}

output "homeassistant_ipv4" {
  description = "IPv4 address of the Home Assistant instance"
  value       = incus_instance.homeassistant.ipv4_address
}

output "homeassistant_macvlan_name" {
  description = "Name of the Home Assistant macvlan instance"
  value       = var.enable_test_instances ? incus_instance.homeassistant_macvlan[0].name : null
}

output "homeassistant_macvlan_ipv4" {
  description = "IPv4 address of the Home Assistant macvlan instance"
  value       = var.enable_test_instances ? incus_instance.homeassistant_macvlan[0].ipv4_address : null
}

output "test_container_name" {
  description = "Name of the test container instance"
  value       = var.enable_test_instances ? incus_instance.test_container[0].name : null
}

output "test_container_ipv4" {
  description = "IPv4 address of the test container instance"
  value       = var.enable_test_instances ? incus_instance.test_container[0].ipv4_address : null
}