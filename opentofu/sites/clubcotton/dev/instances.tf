# Test container instance
resource "incus_instance" "test_container" {
  name      = "test-container"
  image     = "images:ubuntu/jammy"
  type      = "container"
  profiles  = ["container-base"]
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
  name      = "homeassistant"
  image     = "haos"
  type      = "virtual-machine"
  profiles  = ["haos"]
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

# Test Home Assistant OS instance with macvlan networking
resource "incus_instance" "homeassistant_macvlan" {
  name      = "homeassistant-macvlan"
  image     = "haos"
  type      = "virtual-machine"
  profiles  = ["haos-macvlan"]
  project   = "default"

  device {
    name = "eth0"
    type = "nic"

    properties = {
      nictype = "macvlan"
      parent  = var.host_interface
      hwaddr  = "00:16:3e:3d:95:f1"  # Different MAC address from the bridged instance
    }
  }
}