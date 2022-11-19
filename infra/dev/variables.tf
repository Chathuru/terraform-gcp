variable "project_id" {
  type        = string
  description = "The ID of the project where the VPC will be created"
}

variable "network_name" {
  type        = string
  description = "The name of the network"
}

variable "network_description" {
  type        = string
  description = "The description of the network"
  default     = ""
}

variable "deploy_region" {
  type        = string
  description = "The region which is used for resource deployment"
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
}

variable "router_name" {
  type        = string
  description = "The name of the cloud router"
}

variable "nat_gateway_name" {
  type        = string
  description = "The name of the cloud NAT gateway"
}

variable "nat_subnetworks" {
  type        = list(any)
  description = "The list of subnetwork names which should use cloud NAT gateway"
}

variable "private_ip_address" {
  type = list(map(string))
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

variable "cluster_node_locations" {
  type        = list(string)
  description = "The list of zones in which the cluster's nodes are located."
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The GKE cluster's control plane IP range"
  default     = ""
}

variable "node_pools" {
  type = any
  #type        = list(map(string))
  description = "The list of node pools being created"
}

variable "mysql_databases" {
}

variable "mysql_allow_ip_range" {
  type = string
}

variable "mysql_subnetwork_name" {
  type = string
}
##redis variable
#variable "redis_tier" {
#  type = string
#}
#
#variable "redis_version" {
#  type = string
#}
#
#variable "redis_name" {
#  type = string
#}
#
#variable "redis_memory_size_gb" {
#  type = string
#}
#
#variable "redis_auth_string" {
#  type = string
#}
#
#variable "redis_connect_mode" {
#  type = string
#}
#
#variable "redis_location_id" {
#  type = string
#}

variable "compute_instance_name" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "zone" {
  type = string
}

variable "network_tags" {
  type = list(string)
}

variable "compute_instance_image" {
  type = string
}

variable "firewall_rules" {
  type = map(any)
}

variable "cloud_build_triggers" {
  type = map(any)
}

variable "uptime_check" {
  type = map(any)
}

variable "users_credentials" {
  type = map(string)
}

variable "notification_channel_email" {
  type = map(map(string))
}

variable "gke_authorized_networks" {
  type = map(map(string))
}

variable "gke_subnetwork_name" {
  type = string
}

variable "redis_subnetwork_name" {
  type = string
}

variable "redis_instances" {
}

#variable "clouddns_name" {
#  type = string
#}
#
#variable "clouddns_dns_name" {
#  type = string
#}
#
#variable "clouddns_visibility" {
#  type = string
#}
#
#variable "clouddns_description" {
#  type = string
#}
#
#variable "clouddns_dns_records" {
#  type = map(any)
#}

variable "alerting_monitoring_alert_policy" {
  type = map(any)
}

variable "security_policies" {
  type = any
}

variable "tcp-ip-ips" {
  type = list(string)
}