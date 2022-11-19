variable "name" {
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

variable "image" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "firewall_rules" {
  type    = map(any)
  default = {}
}
