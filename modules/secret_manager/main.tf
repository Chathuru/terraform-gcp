
resource "google_secret_manager_secret" "secret" {
  for_each = var.users_credentials

  secret_id = each.key
  labels    = var.secret_lables
  project   = var.project_id

  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "secret-version-basic" {
  for_each = var.users_credentials

  secret      = google_secret_manager_secret.secret[each.key].id
  secret_data = each.value

  depends_on = [google_secret_manager_secret.secret]
}