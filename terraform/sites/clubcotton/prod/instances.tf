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
      hwaddr  = "00:16:3e:3d:95:f2"  # Different MAC address for prod
    }
  }
}