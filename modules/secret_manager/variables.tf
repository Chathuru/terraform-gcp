variable "secret_lables" {
  type    = map(any)
  default = {}
}

variable "users_credentials" {
  type = map(string)
}

variable "project_id" {
  type        = string
  description = "The ID of the project where the VPC will be created"
}
