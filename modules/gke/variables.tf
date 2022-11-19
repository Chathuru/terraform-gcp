variable "project_id" {
  type        = string
  description = "The ID of the project where the VPC will be created"
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "cluster_description" {
  type        = string
  description = "Description of the cluster."
  default     = ""
}

variable "network_name" {
  type        = string
  description = "The name of the Google Compute Engine network to which the cluster is connected"
}

variable "location" {
  type        = string
  description = "The location (region) of the regional cluster in which the cluster master will be created, as well as the default node location"
}

variable "cluster_node_locations" {
  type        = list(string)
  description = "The list of zones in which the cluster's nodes are located."
}

variable "subnetwork_name" {
  type        = string
  description = "The name of the Google Compute Engine subnetwork in which the cluster's instances are launched."
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The GKE cluster's control plane IP range"
  default     = "172.16.0.0/28"
}

variable "node_pools" {
  #type = list(map(any))
  description = "The list of node pools being created"
}

variable "gke_authorized_networks" {
  type = map(any)
}

variable "tcp-ip-ips" {
  type    = list(string)
  default = []
}

variable "ingress-ip-address" {
  type    = list(string)
  default = []
}