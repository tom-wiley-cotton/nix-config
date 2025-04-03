terraform {
  required_providers {
    incus = {
      source  = "lxc/incus"
      version = "0.3.0"
    }
  }
}

provider "incus" {
  # Configuration will be read from environment variables:
  # INCUS_SOCKET_PATH or INCUS_REMOTE
  # INCUS_CLIENT_CERT
  # INCUS_CLIENT_KEY
  # INCUS_SERVER_CERT
  # INCUS_PROJECT
}