terraform {
  required_version = ">= 0.13"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }

  }
}
resource "yandex_vpc_security_group" "security_group" {
  name = "${var.env}-sg-${var.name}"
  description = var.description
  network_id=var.network_id

  labels = var.labels

  //tcp
  dynamic "ingress" {
    for_each = var.allow_tcp_ports
    content {
      protocol    = "tcp"
      description    = "tcp ${ingress.value} allow"
      v4_cidr_blocks      = ["0.0.0.0/0"]
      from_port  = ingress.value
      to_port  = ingress.value
    }
  }
  //tcp
  dynamic "ingress" {
    for_each = var.allow_udp_ports
    content {
      protocol    = "udp"
      description    = "udp ${ingress.value} allow"
      v4_cidr_blocks      = ["0.0.0.0/0"]
      from_port  = ingress.value
      to_port  = ingress.value
    }
  }

  egress {
    protocol       = "ANY"
    description    = "all allow"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port      = -1
  }
}
