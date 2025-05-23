variable "network_bridge" {
  description = "Name of the network bridge to use"
  type        = string
  default     = "br0"
}

variable "host_interface" {
  description = "Name of the host network interface"
  type        = string
  default     = "eno1"
}

variable "storage_pool" {
  description = "Name of the storage pool to use"
  type        = string
  default     = "local"
}

variable "vm_config" {
  description = "Default configuration for virtual machines"
  type        = map(string)
  default     = {
    "limits.cpu"          = "4"
    "limits.memory"       = "8GB"
    "security.secureboot" = "false"
    "boot.autostart"      = "true"
  }
}

variable "container_config" {
  description = "Default configuration for containers"
  type        = map(string)
  default     = {
    "limits.cpu"          = "2"
    "limits.memory"       = "4GB"
    "security.nesting"    = "false"
    "security.privileged" = "false"
    "boot.autostart"      = "true"
  }
}

variable "storage_sizes" {
  description = "Storage sizes for different instance types"
  type        = map(string)
  default     = {
    "vm"        = "64GB"
    "container" = "16GB"
  }
}

variable "base_config" {
  description = "Base configuration for all instances"
  type = object({
    limits_cpu    = string
    limits_memory = string
  })
  default = {
    limits_cpu    = "2"
    limits_memory = "2GB"
  }
}

variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
  default     = "prod"
}