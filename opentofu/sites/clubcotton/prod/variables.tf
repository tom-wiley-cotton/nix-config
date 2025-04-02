variable "network_bridge" {
  description = "Name of the network bridge to use"
  type        = string
  default     = "br0"
}

variable "host_interface" {
  description = "Name of the host network interface"
  type        = string
  default     = "enp3s0"
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
    "limits.cpu"          = "4"    # More resources in prod
    "limits.memory"       = "8GB"  # More resources in prod
    "security.secureboot" = "false"
    "boot.autostart"      = "true"
  }
}

variable "container_config" {
  description = "Default configuration for containers"
  type        = map(string)
  default     = {
    "limits.cpu"          = "2"    # More resources in prod
    "limits.memory"       = "4GB"  # More resources in prod
    "security.nesting"    = "false"
    "security.privileged" = "false"
    "boot.autostart"      = "true"
  }
}

variable "storage_sizes" {
  description = "Storage sizes for different instance types"
  type        = map(string)
  default     = {
    "vm"        = "40GB"  # More storage in prod
    "container" = "20GB"  # More storage in prod
  }
}

variable "base_config" {
  description = "Base configuration for all instances"
  type = object({
    limits_cpu    = string
    limits_memory = string
  })
  default = {
    limits_cpu    = "2"    # More resources in prod
    limits_memory = "2GB"  # More resources in prod
  }
}

variable "enable_test_instances" {
  description = "Whether to create test instances"
  type        = bool
  default     = false  # No test instances in prod
}

variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
  default     = "prod"
}