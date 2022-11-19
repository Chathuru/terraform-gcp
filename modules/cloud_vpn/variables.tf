variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "vpn_gateway_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "shared_secret" {
  type = string
}

variable "peer_ip" {
  type = string
}

variable "subnet_cidr_ranges" {
  type = list(string)
}

variable "remote_subnet_cidr_ranges" {
  type = list(string)
}
