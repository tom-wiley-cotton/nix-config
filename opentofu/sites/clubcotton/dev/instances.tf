# Home Assistant OS instance with bridged networking
resource "incus_instance" "homeassistant" {
  name      = "${var.environment}-homeassistant"
  image     = "haos"
  type      = "virtual-machine"
  profiles  = [module.profiles.haos_profile_name]
  project   = "default"

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "bridged"
      parent  = var.network_bridge
      hwaddr  = "00:16:3e:3d:95:f0"
    }
  }
}

# Home Assistant OS instance with macvlan networking - only in dev
resource "incus_instance" "homeassistant_macvlan" {
  count     = var.enable_test_instances ? 1 : 0
  name      = "${var.environment}-homeassistant-macvlan"
  image     = "haos"
  type      = "virtual-machine"
  profiles  = [module.profiles.haos_macvlan_profile_name]
  project   = "default"

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "macvlan"
      parent  = var.host_interface
      hwaddr  = "00:16:3e:3d:95:f1"
    }
  }
}

# Test container instance - only in dev
resource "incus_instance" "test_container" {
  count     = var.enable_test_instances ? 1 : 0
  name      = "${var.environment}-test-container"
  image     = "images:ubuntu/jammy"
  type      = "container"
  profiles  = [module.profiles.container_profile_name]
  project   = "default"

  config = {
    "boot.autostart" = "true"
    "limits.cpu"     = "1"
  }

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "bridged"
      parent  = var.network_bridge
    }
  }

  device {
    name = "root"
    type = "disk"

    properties = {
      pool = var.storage_pool
      path = "/"
      size = var.storage_sizes["container"]
    }
  }
}