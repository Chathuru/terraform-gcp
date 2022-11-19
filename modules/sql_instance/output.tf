output "databases_list" {
  value = local.databases
}

output "databases_user" {
  value = local.users
}

#output "sql_private_key" {
#  value = google_sql_ssl_cert.client_cert[*].sha1_fingerprint
#}

output "sql_private_key" {
  #sensitive = true
  value = {
    for sql_cert in google_sql_ssl_cert.client_cert :
    sql_cert.instance => sql_cert.private_key
  }
}

output "sql_server_ca_cert" {
  #sensitive = true
  value = {
    for sql_cert in google_sql_ssl_cert.client_cert :
    sql_cert.instance => sql_cert.server_ca_cert
  }
}

output "sql_server_cert" {
  #sensitive = true
  value = {
    for sql_cert in google_sql_ssl_cert.client_cert :
    sql_cert.instance => sql_cert.cert
  }
}
