output "network_name" {
  value       = google_compute_network.network.name
  description = "The name of the network"
}

output "subnetworks" {
  value = {
    for k, v in google_compute_subnetwork.subnetwork :
    k => v.ip_cidr_range
  }
  description = "Subnetworks created"
}

output "subnets" {
  value = local.subnets
}

output "vpc_id" {
  value = google_compute_network.network.id
}

output "vpc_url" {
  value = google_compute_network.network.self_link
}