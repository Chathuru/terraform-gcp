locals {
  notification_channel_ids = flatten([
    for channel in google_monitoring_notification_channel.email : channel.id
  ])
}

resource "google_monitoring_uptime_check_config" "https" {
  for_each = var.uptime_check

  display_name = each.key
  timeout      = "10s"
  period       = "60s"

  http_check {
    path = lookup(each.value, "http_check_path")
    port = "443"

    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = lookup(each.value, "monitored_resource_host")
    }
  }

}

resource "google_monitoring_notification_channel" "email" {
  for_each = var.notification_channel_email

  display_name = each.key
  type         = "email"
  labels = {
    email_address = lookup(each.value, "email_address")
  }
}

#output "notification_channel" {
#  #value = google_monitoring_notification_channel.email
#  value = local.monitoring_notification_channel
#}

resource "google_monitoring_alert_policy" "alert_policy" {
  for_each = var.monitoring_alert_policy

  display_name          = each.key
  combiner              = lookup(each.value, "combiner")
  notification_channels = local.notification_channel_ids

  conditions {
    display_name = lookup(each.value, "conditions_display_name")

    condition_threshold {
      comparison      = lookup(each.value, "condition_threshold_comparison")
      duration        = lookup(each.value, "condition_threshold_duration")
      filter          = lookup(each.value, "condition_threshold_filter")
      threshold_value = lookup(each.value, "condition_threshold_value")

      aggregations {
        alignment_period     = lookup(each.value, "aggregations_alignment_period")
        cross_series_reducer = lookup(each.value, "aggregations_cross_series_reducer")
        group_by_fields      = lookup(each.value, "aggregations_group_by_fields")
        per_series_aligner   = lookup(each.value, "aggregations_per_series_aligner")
      }

      trigger {
        count   = lookup(each.value, "trigger_count")
        percent = lookup(each.value, "trigger_percent")
      }
    }
  }

  depends_on = [google_monitoring_notification_channel.email]
}