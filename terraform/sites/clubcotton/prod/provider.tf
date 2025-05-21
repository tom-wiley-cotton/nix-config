# Configure the Incus provider
terraform {
  required_providers {
    incus = {
      source  = "lxc/incus"
      version = "0.3.0"
    }
  }
}

provider "incus" {
  # Configuration will be read from environment variables
}