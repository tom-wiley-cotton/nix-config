# Base profile for all instances
resource "incus_profile" "base" {
  name = "base"

  config = {
    "limits.cpu"    = local.base_config.limits_cpu
    "limits.memory" = local.base_config.limits_memory
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
    }
  }
}

# Profile for virtual machines
resource "incus_profile" "vm" {
  name = "vm-base"

  config = var.vm_config

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

# Profile for containers
resource "incus_profile" "container" {
  name = "container-base"

  config = var.container_config

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

# Profile for Home Assistant OS with bridged networking
resource "incus_profile" "haos" {
  name = "haos"

  config = {
    "limits.cpu"          = "2"
    "limits.memory"       = "4GB"
    "security.secureboot" = "false"
    "boot.autostart"      = "true"
    "migration.stateful"  = "true"
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
      size = "64GB"
    }
  }
}

# Profile for Home Assistant OS with macvlan networking
resource "incus_profile" "haos_macvlan" {
  name = "haos-macvlan"

  config = {
    "limits.cpu"          = "2"
    "limits.memory"       = "4GB"
    "security.secureboot" = "false"
    "boot.autostart"      = "true"
    "migration.stateful"  = "true"
  }

  device {
    name = "eth0"
    type = "nic"
    
    properties = {
      nictype = "macvlan"
      parent  = var.host_interface
    }
  }

  device {
    name = "root"
    type = "disk"
    
    properties = {
      pool = var.storage_pool
      path = "/"
      size = "64GB"
    }
  }
}