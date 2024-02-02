terraform {
  required_providers {
    cml2 = {
      source  = "CiscoDevNet/cml2"
      version = ">=0.7.0"
    }
  }
}

provider "cml2" {
  # Configuration options
  address  = var.address
  username = var.username
  password = var.password
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
