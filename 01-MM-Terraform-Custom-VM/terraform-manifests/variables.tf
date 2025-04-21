variable "project_id" {}
variable "region" {}
variable "zone" {}

variable "ssh_user" {
  default = "terraform"
}

variable "public_key_path" {
  description = "Path to your public SSH key"
}

variable "private_key_path" {
  description = "Path to your private SSH key"
}
