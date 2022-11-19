variable "mysql_databases" {
}

variable "mysql_replica_databases" {
  default = {}
}

variable "deletion_protection" {
  type    = bool
  default = true
}


variable "public_access" {
  type    = bool
  default = true
}

variable "vpc_id" {
  type    = string
  default = null
}

variable "private_service_connection_name" {
  type    = string
  default = null
}

variable "backup_enable" {
  type    = bool
  default = false
}

variable "binary_log_enabled" {
  type    = bool
  default = false
}

variable "retained_backups" {
  type    = number
  default = 7
}

variable "retention_unit" {
  type    = string
  default = "COUNT"
}


variable "users_credentials" {
  type    = map(string)
  default = {}
}

variable "db_list" {
  type    = list(string)
  default = []
}

variable "mysql_user_host" {
  type = string
}

variable "project_id" {
  type        = string
  description = "The ID of the project where the VPC will be created"
}
