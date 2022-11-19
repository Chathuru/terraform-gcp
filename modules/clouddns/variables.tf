variable "vpc_id" {
  type = string
}

variable "name" {
  type = string
}

variable "dns_name" {
  type = string
}

variable "visibility" {
  type = string
}

variable "description" {
  type = string
}

variable "dns_records" {
  type    = map(any)
  default = {}
}

variable "project_id" {
  type        = string
  description = "The ID of the project where the VPC will be created"
}