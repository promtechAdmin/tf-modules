resource "yandex_vpc_security_group" "vpn_security_group" {
  name = "${var.env} Open VPN Security Group"
  description = ""
  network_id=var.network_id

  labels = var.labels

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      protocol    = ingress.key
      description    = "${ingress.key} ${ingress.value} allow"
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
