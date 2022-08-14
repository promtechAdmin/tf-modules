resource "yandex_vpc_security_group" "vpn_security_group" {
  name = "${var.env} Open VPN Security Group"
  description = ""
  network_id=var.network_id

  labels = var.labels

  dynamic "ingress" {
    for_each = lookup(var.allow_ports,var.env)
    content {
      protocol    = "TCP"
      description    = "TCP ${ingress.value} allow"
      v4_cidr_blocks      = ["0.0.0.0/0"]
      port  = ingress.value
    }
  }
  ingress {
    protocol    = "UDP"
    description    = "UDP 1194  allow"
    v4_cidr_blocks      = ["0.0.0.0/0"]
    from_port  = 1194
    to_port  = 1194
  }

  egress {
    protocol       = "ANY"
    description    = "all allow"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port      = -1
  }
}
