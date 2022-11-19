resource "google_redis_instance" "redis_instance" {
  for_each = var.redis_instances

  name           = each.key
  project        = var.project_id
  tier           = lookup(each.value, "tier")
  memory_size_gb = lookup(each.value, "memory_size_gb")

  location_id  = lookup(each.value, "location_id")
  auth_enabled = var.auth_enabled
  #auth_string    = data.google_secret_manager_secret_version.passwords

  redis_version = lookup(each.value, "version")
  display_name  = each.key

  authorized_network = var.vpc_id
  secondary_ip_range = var.redis_subnetwork_name
  connect_mode       = lookup(each.value, "connect_mode")

  transit_encryption_mode = var.transit_encryption_mode


  maintenance_policy {
    weekly_maintenance_window {
      day = "TUESDAY"
      start_time {
        hours   = 0
        minutes = 30
        seconds = 0
        nanos   = 0
      }
    }
  }

  lifecycle {
    ignore_changes = [
      secondary_ip_range
    ]
  }
}
