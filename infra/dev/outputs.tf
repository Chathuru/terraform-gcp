#output "network_name" {
#  description = "The name of the created network"
#  value       = module.networking.network_name
#}
#
#output "subnetworks" {
#  description = "Subnetworks created"
#  value       = module.networking.subnetworks
#}
#
#output "subnets" {
#  value = module.networking.subnets
#}

#output "database_list" {
#  value = module.sql.databases_list
#}
#
#output "database_user" {
#  value = module.sql.databases_user
#}

output "sql_private_key" {
  sensitive = true
  value     = module.sql.sql_private_key
}

output "sql_server_ca_cert" {
  sensitive = true
  value     = module.sql.sql_server_ca_cert
}

output "sql_server_cert" {
  sensitive = true
  value     = module.sql.sql_server_cert
}

output "ingress-ip-address" {
  value = module.gke.ingress-ip-address
}

output "tcp-lb-ip-address" {
  value = module.gke.tcp-lb-ip-address
}