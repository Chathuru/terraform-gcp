resource "google_compute_security_policy" "policy" {
  for_each = var.security_policies
  name     = each.key
  #name = "seglan-cloudflare-https-allow"

  dynamic "rule" {
    for_each = lookup(each.value, "rules", null)

    content {
      action   = rule.value["action"]
      priority = rule.value["priority"]
      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = rule.value["src_ip_ranges"]
        }
      }
      description = rule.key
    }
  }
}


#  rule {
#    for_each = var.security_policies
#
#    action   = lookup(each.value, "action")
#    priority = lookup(each.value, "priority")
#    match {
#      versioned_expr = "SRC_IPS_V1"
#      config {
#        src_ip_ranges = lookup(each.value, "src_ip_ranges")
#      }
#    }
#    description = each.key
#  }
