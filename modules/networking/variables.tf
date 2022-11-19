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
  description = "The region which is used for the resource deployment"
}

variable "subnets" {
  type        = list(map(string))
  description = "The list of subnets being created"
}

variable "proxy_only_subnets" {
  type    = list(map(string))
  default = []
}

variable "private_ip_address" {
  type = list(map(string))
}

variable "purpose" {
  type    = string
  default = "VPC_PEERING"

  validation {
    condition     = var.purpose == "VPC_PEERING" || var.purpose == "PRIVATE_SERVICE_CONNECT"
    error_message = "Should be \"VPC_PEERING\" or \"PRIVATE_SERVICE_CONNECT\"."
  }
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
