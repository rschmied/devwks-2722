terraform {
  required_providers {
    cml2 = {
      source = "registry.terraform.io/ciscodevnet/cml2"
      version = ">=0.6.2"
    }
  }
}

provider "cml2" {
  address = var.address
  username = var.username
  password = var.password
}

resource "cml2_lab" "this" {
  title = "micro"
}


resource "cml2_node" "ext-conn-0" {
  lab_id         = cml2_lab.this.id
  label          = "ext-conn-0"
  nodedefinition = "external_connector"
  configuration  = file("ext-conn-0-default.cfg")
  x              = -360
  y              = -120
  tags           = [ "infra" ]
}

resource "cml2_node" "unmanaged-switch-0" {
  lab_id         = cml2_lab.this.id
  label          = "unmanaged-switch-0"
  nodedefinition = "unmanaged_switch"
  x              = -200
  y              = -120
  tags           = [ "infra" ]
}

resource "cml2_node" "iol-0" {
  lab_id         = cml2_lab.this.id
  label          = "iol-0"
  nodedefinition = "iol-xe"
  configuration  = file("iol-0-ios_config.txt.cfg")
  x              = -40
  y              = -120
  tags           = ["pat:xxxx:22", "core"]
}

resource "cml2_node" "server-0" {
  lab_id         = cml2_lab.this.id
  label          = "server-0"
  nodedefinition = "server"
  configuration  = file("server-0-iosxe_config.txt.cfg")
  x              = 120
  y              = -120
  tags           = [ "access" ]
}



resource "cml2_link" "l0" {
  lab_id         = cml2_lab.this.id
  node_a         = cml2_node.ext-conn-0.id
  slot_a         = 0
  node_b         = cml2_node.unmanaged-switch-0.id
  slot_b         = 0
}

resource "cml2_link" "l1" {
  lab_id         = cml2_lab.this.id
  node_a         = cml2_node.unmanaged-switch-0.id
  slot_a         = 1
  node_b         = cml2_node.iol-0.id
  slot_b         = 0
}

resource "cml2_link" "l2" {
  lab_id         = cml2_lab.this.id
  node_a         = cml2_node.iol-0.id
  slot_a         = 1
  node_b         = cml2_node.server-0.id
  slot_b         = 0
}


resource "cml2_lifecycle" "lc" {
  lab_id     = cml2_lab.this.id
  # elements is needed for 0.7.0
  elements   = []
  # depends on is the "native" replacement for elements
  depends_on = [
    cml2_link.l0,
    cml2_link.l1,
    cml2_link.l2,
  ]
  state = "STARTED"
}
