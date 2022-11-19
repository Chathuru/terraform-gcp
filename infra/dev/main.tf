provider "google" {
  project = "test"
  region  = "us-east1"
}

provider "google-beta" {
  alias   = "beta"
  project = "test"
  region  = "us-east1"
}

module "networking" {
  source = "../../modules/networking"
  providers = {
    google-beta = google-beta.beta
  }
  network_name       = var.network_name
  project_id         = var.project_id
  deploy_region      = var.deploy_region
  subnets            = var.subnets
  router_name        = var.router_name
  nat_gateway_name   = var.nat_gateway_name
  nat_subnetworks    = var.nat_subnetworks
  private_ip_address = var.private_ip_address
}

module "sql" {
  source = "../../modules/sql_instance"
  providers = {
    google-beta = google-beta.beta
  }
  mysql_databases                 = var.mysql_databases
  vpc_id                          = module.networking.vpc_id
  mysql_user_host                 = var.mysql_allow_ip_range
  users_credentials               = {}
  private_service_connection_name = var.mysql_subnetwork_name
  backup_enable                   = true
  binary_log_enabled              = true
  project_id                      = var.project_id

  depends_on = [module.networking, module.secret_manager]
}

module "google_redis" {
  source                = "../../modules/google_redis"
  vpc_id                = module.networking.vpc_id
  redis_instances       = var.redis_instances
  redis_subnetwork_name = var.redis_subnetwork_name
  project_id            = var.project_id
  depends_on            = [module.networking, module.secret_manager]
}

module "gke" {
  source                  = "../../modules/gke"
  project_id              = var.project_id
  cluster_name            = var.cluster_name
  network_name            = var.network_name
  location                = var.deploy_region
  cluster_node_locations  = var.cluster_node_locations
  subnetwork_name         = var.gke_subnetwork_name
  node_pools              = var.node_pools
  gke_authorized_networks = var.gke_authorized_networks
  tcp-ip-ips              = var.tcp-ip-ips
  depends_on              = [module.networking]
}

module "cloud_build" {
  source     = "../../modules/cloudbuild"
  triggers   = var.cloud_build_triggers
  project_id = var.project_id
}

module "secret_manager" {
  source            = "../../modules/secret_manager"
  users_credentials = var.users_credentials
  project_id        = var.project_id

  depends_on = [module.networking]
}

module "security_policy" {
  source            = "../../modules/security_policy"
  security_policies = var.security_policies
}
