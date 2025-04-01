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