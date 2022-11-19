resource "google_compute_instance" "compute-instance" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image # https://cloud.google.com/compute/docs/images/os-details#general-info
    }
  }

  network_interface {
    network    = var.vpc_name
    subnetwork = var.subnet_name

    access_config {}
  }
  #  metadata = {
  #    foo = "bar"
  #  }

  tags = var.network_tags
  #metadata_startup_script = "echo hi > /test.txt"

}

resource "google_compute_firewall" "firewall-rule" {
  for_each = var.firewall_rules

  name    = each.key
  network = var.vpc_name

  allow {
    protocol = lookup(each.value, "protocol")
    ports    = lookup(each.value, "ports", [])
  }

  source_ranges = lookup(each.value, "source_ranges", ["0.0.0.0/0"])
  target_tags   = var.network_tags
}
