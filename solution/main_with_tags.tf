terraform {
  required_providers {
    cml2 = {
      source  = "registry.terraform.io/ciscodevnet/cml2"
      version = ">=0.6.2"
    }
  }
}

provider "cml2" {
  address  = var.address
  username = var.username
  password = var.password
}

resource "cml2_lab" "this" {
  title = "clemea25-demo"
}


resource "cml2_node" "access01" {
  lab_id         = cml2_lab.this.id
  label          = "access01"
  nodedefinition = "ioll2-xe"
  configuration  = file("access01-ios_config.txt.cfg")
  x              = -200
  y              = 0
  tags           = ["core"]
}

resource "cml2_node" "server01" {
  lab_id         = cml2_lab.this.id
  label          = "server01"
  nodedefinition = "ioll2-xe"
  configuration  = file("server01-ios_config.txt.cfg")
  x              = 0
  y              = 0
  tags           = ["core"]
}

resource "cml2_node" "firefox-0" {
  lab_id          = cml2_lab.this.id
  label           = "firefox-0"
  nodedefinition  = "firefox"
  imagedefinition = "firefox-buster"
  configuration   = file("firefox-0-boot.sh.cfg")
  x               = -400
  y               = 0
  tags            = ["clients"]
}

resource "cml2_node" "nginx-0" {
  lab_id         = cml2_lab.this.id
  label          = "nginx-0"
  nodedefinition = "nginx"
  configuration  = file("nginx-0-boot.sh.cfg")
  x              = 200
  y              = 0
  tags           = ["servers"]
}



resource "cml2_link" "l0" {
  lab_id = cml2_lab.this.id
  node_a = cml2_node.access01.id
  slot_a = 0
  node_b = cml2_node.server01.id
  slot_b = 0
}

resource "cml2_link" "l1" {
  lab_id = cml2_lab.this.id
  node_a = cml2_node.firefox-0.id
  slot_a = 0
  node_b = cml2_node.access01.id
  slot_b = 1
}

resource "cml2_link" "l2" {
  lab_id = cml2_lab.this.id
  node_a = cml2_node.server01.id
  slot_a = 1
  node_b = cml2_node.nginx-0.id
  slot_b = 0
}


resource "cml2_lifecycle" "lc" {
  lab_id = cml2_lab.this.id
  # elements is still required up to version 0.7.0
  # elements = []
  # depends_on is the "native" replacement for elements
  depends_on = [
    cml2_link.l0,
    cml2_link.l1,
    cml2_link.l2,
  ]
  staging = {
    stages = [
      "core",
      "servers",
      "clients"
    ]
    start_remaining = false
  }
  state = "STARTED"
}
