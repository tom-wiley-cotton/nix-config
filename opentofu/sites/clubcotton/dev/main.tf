# Variables for reuse across configurations
locals {
  base_config = {
    limits_cpu    = "1"
    limits_memory = "1GB"
  }
}