# Home Assistant OS image (split format)
resource "incus_image" "haos" {
  source_file = {
    data_path     = "../../../images/haos/haos_ova-15.2.qcow2"
    metadata_path = "../../../images/haos/metadata.tar.gz"
  }

  aliases = ["haos"]
  project = "default"
}
