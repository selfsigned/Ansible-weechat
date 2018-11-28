variable "region" {
  default = "eu-west-3"
}

variable "ssh_pubkey_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "ssh_privkey_path" {
  default = "~/.ssh/id_rsa"
}

variable "drive_size" {
  description = "Root drive space"
  default     = "8"
}
