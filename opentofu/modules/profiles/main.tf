# Base profile for all instances
resource "incus_profile" "base" {
  name = "${var.environment}-base"

  config = {
    "limits.cpu"    = var.base_config.limits_cpu
    "limits.memory" = var.base_config.limits_memory
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
  name = "${var.environment}-vm-base"

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
  name = "${var.environment}-container-base"

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
  name = "${var.environment}-haos"

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
  name = "${var.environment}-haos-macvlan"

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