variable "uptime_check" {
  type = map(any)
}

variable "project_id" {
  type = string
}

variable "notification_channel_email" {
  type = map(map(string))
}

variable "monitoring_alert_policy" {
  type = map(any)
}