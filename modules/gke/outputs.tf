#output "ingress-ip-address" {
#  value = google_compute_global_address.static.address
#}

output "tcp-lb-ip-address" {
  value = google_compute_address.tcp-lb.*.address
}
