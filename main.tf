terraform {
  required_providers {
    cml2 = {
      source  = "CiscoDevNet/cml2"
      version = ">=0.8.0"
    }
  }
}

provider "cml2" {
  # Configuration options
  address  = var.address
  username = var.username
  password = var.password
  # token       = var.token
  # skip_verify = true
}

variable "address" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type      = string
  sensitive = true
}
