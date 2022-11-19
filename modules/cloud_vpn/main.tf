resource "google_compute_vpn_gateway" "vpn_gateway" {
  name    = var.vpn_gateway_name
  network = var.vpc_id
  project = var.project
  region  = var.region
}

resource "google_compute_vpn_tunnel" "vpn_tunnel" {
  name                    = join("-", [var.vpn_gateway_name, "tunnel"])
  shared_secret           = var.shared_secret
  project                 = var.project
  region                  = var.region
  peer_ip                 = var.peer_ip
  local_traffic_selector  = var.subnet_cidr_ranges
  remote_traffic_selector = var.remote_subnet_cidr_ranges
  target_vpn_gateway      = google_compute_vpn_gateway.vpn_gateway.id

  depends_on = [google_compute_forwarding_rule.rule_esp, google_compute_forwarding_rule.rule_udp500, google_compute_forwarding_rule.rule_udp4500]
}

resource "google_compute_route" "route" {
  count      = length(var.remote_subnet_cidr_ranges)
  name       = join("-", [var.vpn_gateway_name, "route", count.index])
  project    = var.project
  network    = var.vpc_id
  dest_range = var.remote_subnet_cidr_ranges[count.index]
  priority   = 1000

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.vpn_tunnel.id
}

resource "google_compute_forwarding_rule" "rule_esp" {
  name        = join("-", [var.vpn_gateway_name, "rule-esp"])
  ip_protocol = "ESP"
  region      = var.region
  project     = var.project
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.vpn_gateway.id

  depends_on = [google_compute_vpn_gateway.vpn_gateway, google_compute_address.vpn_static_ip]
}

resource "google_compute_forwarding_rule" "rule_udp500" {
  name        = join("-", [var.vpn_gateway_name, "rule-udp500"])
  ip_protocol = "UDP"
  port_range  = "500"
  region      = var.region
  project     = var.project
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.vpn_gateway.id

  depends_on = [google_compute_vpn_gateway.vpn_gateway, google_compute_address.vpn_static_ip]
}

resource "google_compute_forwarding_rule" "rule_udp4500" {
  name        = join("-", [var.vpn_gateway_name, "rule-udp4500"])
  ip_protocol = "UDP"
  port_range  = "4500"
  region      = var.region
  project     = var.project
  ip_address  = google_compute_address.vpn_static_ip.address
  target      = google_compute_vpn_gateway.vpn_gateway.id

  depends_on = [google_compute_vpn_gateway.vpn_gateway, google_compute_address.vpn_static_ip]
}

resource "google_compute_address" "vpn_static_ip" {
  name    = join("-", [var.vpn_gateway_name, "vpn-static-ip"])
  project = var.project
  region  = var.region
}
