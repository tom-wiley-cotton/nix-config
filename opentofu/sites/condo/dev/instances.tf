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
    }
  }

  device {
    name = "root"
    type = "disk"

    properties = {
      pool = var.storage_pool
      path = "/"
      size = var.storage_sizes["vm"]
    }
  }
}