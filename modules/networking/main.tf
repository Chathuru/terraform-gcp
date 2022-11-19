locals {
  subnets = {
    for s in var.subnets :
    "${s.subnet_name}" => s
  }

  proxy_only_subnets = {
    for s in var.proxy_only_subnets :
    "${s.subnet_name}" => s
  }

  private_connection_names = flatten([
    for private_connection in var.private_ip_address : [
      private_connection.name
    ]
  ])
}

resource "google_compute_address" "static" {
  name    = "nat-ip-address"
  project = var.project_id
  region  = var.deploy_region
}

resource "google_compute_network" "network" {
  project                 = var.project_id
  name                    = var.network_name
  description             = var.network_description
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  for_each                 = local.subnets
  name                     = each.value.subnet_name
  ip_cidr_range            = each.value.subnet_cidr
  description              = each.value.description
  region                   = var.deploy_region
  network                  = google_compute_network.network.id
  project                  = var.project_id
  private_ip_google_access = lookup(each.value, "subnet_private_access", "false")
}

resource "google_compute_subnetwork" "proxy_only_subnets" {
  for_each      = local.proxy_only_subnets
  name          = each.value.subnet_name
  ip_cidr_range = each.value.subnet_cidr
  purpose       = each.value.purpose
  role          = each.value.role
  region        = var.deploy_region
  network       = google_compute_network.network.id
  project       = var.project_id
}

resource "google_compute_router" "router" {
  name    = var.router_name
  project = var.project_id
  network = google_compute_network.network.id
  region  = var.deploy_region
}

resource "google_compute_router_nat" "nat" {
  name    = var.nat_gateway_name
  router  = google_compute_router.router.name
  region  = google_compute_router.router.region
  project = var.project_id
  #nat_ip_allocate_option             = "AUTO_ONLY"
  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = [google_compute_address.static.self_link]

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  dynamic "subnetwork" {
    for_each = var.nat_subnetworks
    iterator = nat_subnet
    content {
      name                    = google_compute_subnetwork.subnetwork[nat_subnet.value].id
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }
  enable_endpoint_independent_mapping = false
  min_ports_per_vm                    = 64
  # subnetwork {
  #   name                    = google_compute_subnetwork.subnetwork.id
  #   source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  # }
  depends_on = [google_compute_address.static]
}

#locals {
#  private_ip_range_names = flatten([
#    for region in var.private_ip_address : [
#      region.name
#    ]
#  ])
#}

resource "google_compute_global_address" "private_ip_address" {
  count    = length(var.private_ip_address)
  provider = google-beta

  name          = lookup(var.private_ip_address[count.index], "name")
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = lookup(var.private_ip_address[count.index], "prefix_length")
  address       = lookup(var.private_ip_address[count.index], "address")
  network       = google_compute_network.network.id
  labels        = {}
}

resource "google_service_networking_connection" "private_service_connection" {
  provider = google-beta

  network                 = google_compute_network.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = local.private_connection_names

  depends_on = [google_compute_global_address.private_ip_address]
}
