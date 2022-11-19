locals {
  node_pools = {
    for np in var.node_pools :
    "${np.pool_name}" => np
  }
}

resource "google_compute_global_address" "static" {
  count = length(var.ingress-ip-address)

  name    = join("-", [var.cluster_name, var.ingress-ip-address[count.index]])
  project = var.project_id
}

resource "google_compute_address" "tcp-lb" {
  count = length(var.tcp-ip-ips)

  name    = join("-", [var.cluster_name, var.tcp-ip-ips[count.index]])
  region  = var.location
  project = var.project_id
}


resource "google_container_cluster" "primary" {
  name           = var.cluster_name
  description    = var.cluster_description
  project        = var.project_id
  location       = var.location
  node_locations = var.cluster_node_locations
  network        = var.network_name
  subnetwork     = var.subnetwork_name

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  network_policy {
    enabled  = true
    provider = "CALICO"
  }
  #   network_policy {
  #     enabled = true
  #   }
  release_channel {
    channel = "REGULAR"
  }

  default_snat_status {
    disabled = false
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.gke_authorized_networks

      content {
        cidr_block   = cidr_blocks.value["cidr_block"]
        display_name = cidr_blocks.value["display_name"]
      }
    }
  }
  ip_allocation_policy {

  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block

    master_global_access_config {
      enabled = true
    }

  }
  initial_node_count       = 1
  remove_default_node_pool = true
}


resource "google_container_node_pool" "pools" {
  for_each       = local.node_pools
  name           = each.key
  project        = var.project_id
  location       = each.value.location
  node_locations = split(",", each.value["node_locations"])
  cluster        = google_container_cluster.primary.id
  node_count     = each.value.node_count
  node_config {
    image_type      = each.value.image_type
    machine_type    = each.value.machine_type
    service_account = google_service_account.cluster_service_account.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
      #       "https://www.googleapis.com/auth/devstorage.read_only",
      #       "https://www.googleapis.com/auth/logging.write",
      #       "https://www.googleapis.com/auth/monitoring",
      #       "https://www.googleapis.com/auth/trace.append",
      #       "https://www.googleapis.com/auth/devstorage.full_control"
    ]
    labels = each.value.labels

  }
}

resource "google_service_account" "cluster_service_account" {
  project      = var.project_id
  account_id   = "tf-gke-${google_container_cluster.primary.name}-sa"
  display_name = "tf-gke-${google_container_cluster.primary.name}-sa"
}

resource "google_project_iam_member" "cluster_service_account-log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
}

resource "google_project_iam_member" "cluster_service_account-metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
}

resource "google_project_iam_member" "cluster_service_account-monitoring_viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
}

resource "google_project_iam_member" "cluster_service_account-resourceMetadata-writer" {
  project = var.project_id
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
}

resource "google_project_iam_member" "cluster_service_account-storage-object-viewer" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.cluster_service_account.email}"
}

resource "google_compute_ssl_policy" "custom-ssl-policy" {
  project         = var.project_id
  name            = join("-", [var.cluster_name, "ssl-tls12"])
  min_tls_version = "TLS_1_2"
  profile         = "RESTRICTED"
}