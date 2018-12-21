variable "project_id" {
  default = "upodroid"
}

variable "name" {
  default = "tf-default"
}

variable "gcrimage" {
  default = "none"
}

variable "instancename" {
  default = "none"
}
variable "machine_type" {
  default = "g1-small"
}

variable "zone" {
  description = "Default Zone"
  default     = "europe-west2-b"
}

variable "region" {
  description = "Default Zone"
  default     = "europe-west2"
}

variable "network" {
  default = "upo"
}

variable "ssh_user" {
  default = "terraform"
}

variable "public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "private_key" {
  default = "~/.ssh/id_rsa"
}