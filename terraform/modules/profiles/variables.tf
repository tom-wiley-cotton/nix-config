variable "environment" {
  description = "Environment name (dev/prod)"
  type        = string
}

variable "network_bridge" {
  description = "Name of the network bridge to use"
  type        = string
}

variable "host_interface" {
  description = "Name of the host network interface"
  type        = string
}

variable "storage_pool" {
  description = "Name of the storage pool to use"
  type        = string
}

variable "vm_config" {
  description = "Default configuration for virtual machines"
  type        = map(string)
}

variable "container_config" {
  description = "Default configuration for containers"
  type        = map(string)
}

variable "storage_sizes" {
  description = "Storage sizes for different instance types"
  type        = map(string)
}

variable "base_config" {
  description = "Base configuration for all instances"
  type = object({
    limits_cpu    = string
    limits_memory = string
  })
}