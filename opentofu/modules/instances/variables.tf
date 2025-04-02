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

variable "storage_sizes" {
  description = "Storage sizes for different instance types"
  type        = map(string)
}

variable "container_profile" {
  description = "Name of the container profile to use"
  type        = string
}

variable "haos_profile" {
  description = "Name of the Home Assistant OS profile to use"
  type        = string
}

variable "haos_macvlan_profile" {
  description = "Name of the Home Assistant OS macvlan profile to use"
  type        = string
}

variable "haos_mac_address" {
  description = "MAC address for Home Assistant OS instance"
  type        = string
  default     = "00:16:3e:3d:95:f0"
}

variable "haos_macvlan_mac_address" {
  description = "MAC address for Home Assistant OS macvlan instance"
  type        = string
  default     = "00:16:3e:3d:95:f1"
}

variable "enable_test_instances" {
  description = "Whether to create test instances"
  type        = bool
  default     = false
}