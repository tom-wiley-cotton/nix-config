# Test container instance - only created when enable_test_instances is true
resource "incus_instance" "test_container" {
  count     = var.enable_test_instances ? 1 : 0
  name      = "${var.environment}-test-container"
  image     = "images:ubuntu/jammy"
  type      = "container"
  profiles  = [var.container_profile]
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

# Home Assistant OS instance with bridged networking
resource "incus_instance" "homeassistant" {
  name      = "${var.environment}-homeassistant"
  image     = "haos"
  type      = "virtual-machine"
  profiles  = [var.haos_profile]
  project   = "default"

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "bridged"
      parent  = var.network_bridge
      hwaddr  = var.haos_mac_address
    }
  }
}

# Home Assistant OS instance with macvlan networking - only created when enable_test_instances is true
resource "incus_instance" "homeassistant_macvlan" {
  count     = var.enable_test_instances ? 1 : 0
  name      = "${var.environment}-homeassistant-macvlan"
  image     = "haos"
  type      = "virtual-machine"
  profiles  = [var.haos_macvlan_profile]
  project   = "default"

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "macvlan"
      parent  = var.host_interface
      hwaddr  = var.haos_macvlan_mac_address
    }
  }
}