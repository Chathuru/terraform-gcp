variable "project_id" {
  type        = string
  description = "The ID of the project where the VPC will be created"
}

variable "redis_instances" {
}

variable "auth_enabled" {
  type    = bool
  default = true
}

variable "transit_encryption_mode" {
  type    = string
  default = "SERVER_AUTHENTICATION"
}

variable "redis_subnetwork_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

#
#variable "display_name" {
#  type    = string
#  default = ""
#}
#
#variable "tier" {
#  type = string
#
#  validation {
#    condition     = var.tier == "STANDARD_HA" || var.tier == "BASIC"
#    error_message = "Valid values are STANDARD_HA and BASIC."
#  }
#}
#
#variable "memory_size_gb" {
#  type = number
#}
#
#
#
#
#
#variable "auth_string" {
#  type = string
#}
#
#
#variable "connect_mode" {
#  type = string
#}
#
#variable "location_id" {
#  type = string
#}
#
#variable "redis_version" {
#  type = string
#
#  validation {
#    condition     = can(regex("REDIS_\\d_\\w", var.redis_version)) && split("_", var.redis_version)[1] >= 3
#    error_message = "Redis version error."
#  }
#}
