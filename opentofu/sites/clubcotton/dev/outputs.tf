# Local values to collect instance information
locals {
  # Collect all instances
  instances = merge(
    {
      "homeassistant" = {
        name     = incus_instance.homeassistant.name
        type     = incus_instance.homeassistant.type
        status   = incus_instance.homeassistant.status
        location = incus_instance.homeassistant.target
        ip       = incus_instance.homeassistant.ipv4_address
        profile  = "dev-haos"
        resources = {
          cpu    = "2"
          memory = "4GB"
          disk   = "64GB"
        }
      }
    },
    var.enable_test_instances ? {
      "homeassistant_macvlan" = {
        name     = incus_instance.homeassistant_macvlan[0].name
        type     = incus_instance.homeassistant_macvlan[0].type
        status   = incus_instance.homeassistant_macvlan[0].status
        location = incus_instance.homeassistant_macvlan[0].target
        ip       = incus_instance.homeassistant_macvlan[0].ipv4_address
        profile  = "dev-haos-macvlan"
        resources = {
          cpu    = "2"
          memory = "4GB"
          disk   = "64GB"
        }
      }
      "test_container" = {
        name     = incus_instance.test_container[0].name
        type     = incus_instance.test_container[0].type
        status   = incus_instance.test_container[0].status
        location = incus_instance.test_container[0].target
        ip       = incus_instance.test_container[0].ipv4_address
        profile  = "dev-container-base"
        resources = {
          cpu    = var.container_config["limits.cpu"]
          memory = var.container_config["limits.memory"]
          disk   = var.storage_sizes["container"]
        }
      }
    } : {}
  )

  # Calculate total resource allocation
  total_resources = {
    cpu = sum([
      for instance in local.instances :
      tonumber(replace(instance.resources.cpu, "/[^0-9]/", ""))
    ])
    memory_gb = sum([
      for instance in local.instances :
      tonumber(replace(instance.resources.memory, "GB", ""))
    ])
    disk_gb = sum([
      for instance in local.instances :
      tonumber(replace(instance.resources.disk, "GB", ""))
    ])
  }
}

# Output instance information
output "instances" {
  description = "Information about all managed instances"
  value = {
    for name, instance in local.instances :
    name => {
      "Name"     = instance.name
      "Type"     = instance.type
      "Status"   = instance.status
      "Location" = instance.location
      "IP"       = instance.ip
      "Profile"  = instance.profile
      "Resources" = {
        "CPU"    = instance.resources.cpu
        "Memory" = instance.resources.memory
        "Disk"   = instance.resources.disk
      }
    }
  }
}

# Environment summary
output "environment_summary" {
  description = "Summary of the environment configuration"
  value = {
    "Environment"     = var.environment
    "Network Bridge"  = var.network_bridge
    "Host Interface" = var.host_interface
    "Storage Pool"   = var.storage_pool
    "Test Mode"      = var.enable_test_instances ? "Enabled" : "Disabled"
    "Instance Count" = length(local.instances)
    "Total Resources" = {
      "CPU Cores"    = "${local.total_resources.cpu} cores"
      "Memory"       = "${local.total_resources.memory_gb} GB"
      "Storage"      = "${local.total_resources.disk_gb} GB"
    }
  }
}