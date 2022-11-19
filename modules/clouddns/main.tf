resource "google_dns_managed_zone" "private-zone" {
  name        = var.name
  dns_name    = var.dns_name
  description = var.description
  project = var.project_id

  visibility = var.visibility

  private_visibility_config {
    networks {
      network_url = var.vpc_id
    }
  }
}

resource "google_dns_record_set" "dns_records" {
  for_each = var.dns_records

  project = var.project_id
  name    = each.key
  type    = lookup(each.value, "type", "A")
  ttl     = lookup(each.value, "ttl", 300)
  rrdatas = lookup(each.value, "ip_address")

  managed_zone = google_dns_managed_zone.private-zone.name

  depends_on = [google_dns_managed_zone.private-zone]
}
