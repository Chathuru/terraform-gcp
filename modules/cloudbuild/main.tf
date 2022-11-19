resource "google_cloudbuild_trigger" "cloudbuild_trigger" {
  for_each = var.triggers

  name        = each.key
  description = lookup(each.value, "description", "")
  project     = var.project_id
  #service_account = google_service_account.cloudbuild_service_account.id

  git_file_source {
    path      = "cloudbuild.yaml"
    uri       = lookup(each.value, "git_repo")
    revision  = "refs/heads/master"
    repo_type = "CLOUD_SOURCE_REPOSITORIES"
  }

  source_to_build {
    uri       = lookup(each.value, "git_repo")
    ref       = "refs/heads/master"
    repo_type = "CLOUD_SOURCE_REPOSITORIES"
  }
  #filename = lookup(each.value, "filename", "cloudbuild.yaml")

  #  trigger_template {
  #    branch_name  = lookup(each.value, "branch_name", ".*")
  #    repo_name    = lookup(each.value, "repo_name")
  #    invert_regex = lookup(each.value, "invert_regex", false)
  #  }

  depends_on = [google_service_account.cloudbuild_service_account]
}

resource "google_service_account" "cloudbuild_service_account" {
  project      = var.project_id
  account_id   = "${var.project_id}-cloudbuild-sa"
  display_name = "${var.project_id}-cloudbuild-sa"
}

resource "google_project_iam_member" "cloudbuild_service_account_act_as" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"

  depends_on = [google_service_account.cloudbuild_service_account]
}

resource "google_project_iam_member" "cloudbuild_service_account_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"

  depends_on = [google_service_account.cloudbuild_service_account]
}

resource "google_project_iam_member" "cloudbuild_service_account_storage_object_admin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"

  depends_on = [google_service_account.cloudbuild_service_account]
}

resource "google_project_iam_member" "cloudbuild_service_account_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"

  depends_on = [google_service_account.cloudbuild_service_account]
}

resource "google_project_iam_member" "cloudbuild_service_account_artifactregistry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"

  depends_on = [google_service_account.cloudbuild_service_account]
}

resource "google_project_iam_member" "cloudbuild_service_account_sourcerepo_service_agent" {
  project = var.project_id
  role    = "roles/sourcerepo.serviceAgent"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"

  depends_on = [google_service_account.cloudbuild_service_account]
}

resource "google_project_iam_member" "cloudbuild_service_account_secretmanager_viewer" {
  project = var.project_id
  role    = "roles/secretmanager.viewer"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"

  depends_on = [google_service_account.cloudbuild_service_account]
}

resource "google_project_iam_member" "cloudbuild_service_account_secretmanager_secretaccessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"

  depends_on = [google_service_account.cloudbuild_service_account]
}

resource "google_project_iam_member" "cloudbuild_service_account_cloudbuild_service_agent" {
  project = var.project_id
  role    = "roles/cloudbuild.serviceAgent"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"

  depends_on = [google_service_account.cloudbuild_service_account]
}

resource "google_project_iam_member" "cloudbuild_service_account_run_service_agent" {
  project = var.project_id
  role    = "roles/run.serviceAgent"
  member  = "serviceAccount:${google_service_account.cloudbuild_service_account.email}"

  depends_on = [google_service_account.cloudbuild_service_account]
}