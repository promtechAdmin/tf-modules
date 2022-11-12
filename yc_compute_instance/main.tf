terraform {
  required_version = ">= 0.8"

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
locals {
  labels = merge(var.labels, { name = "${var.env}_${var.instance_name}" })
}
#========================================================================
data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

#data "template_file" "cloud_init" {
#    template = file("${path.module}/cloud-init.tmpl.yaml")
#    vars     = {
#    user     = var.user_login
#    ssh_key  = file(var.public_key_path)
#  }
#}
#========================================================================
resource "yandex_compute_disk" "secondary_disk" {
  count  = length(var.secondary_disk_names)
  name   = "${var.env}-${var.secondary_disk_names[count.index]}${count.index+1}"
  type   = "network-ssd"
  zone   = var.zone
  size   = var.secondary_disk_size
  labels = local.labels
}

resource "yandex_compute_instance" "server" {
  count       = var.instance_count
  name        = "${var.env}-s${count.index+1}${var.instance_role}-${var.instance_name}-sever"
  #platform_id = lookup(var.instance_platform,var.env)
  platform_id = var.instance_platform
  zone        = var.zone
  hostname    = "${var.env}-s${count.index+1}${var.instance_role}-${var.instance_name}-server.${var.domain_fqdn}"

  labels = local.labels

  resources {
    core_fraction = var.core_fraction
    cores         = var.cores
    memory        = var.memory

  }
  boot_disk {
    initialize_params {
      image_id = var.disk_image == null ? data.yandex_compute_image.ubuntu.id : var.disk_image
      type     = var.disk_type
      size     = var.disk_size
    }
  }
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.secondary_disk
    content {
      disk_id = secondary_disk.value.id
      #     device_name = secondary_disk.value.name
    }
  }
  network_interface {
    subnet_id          = var.subnet_id
    nat                = var.is_nat
    nat_ip_address     = var.nat_ip_address
    ip_address         = var.ip_address
    security_group_ids = var.security_group_ids
    ipv6               = false
  }

  metadata = {
    user-data          = var.user_data
    serial-port-enable = 1
  }

  #  provisioner "remote-exec" {
  #    inline =var.instance_init_script
  #    connection {
  #      type  = "ssh"
  #      user  = var.user_login
  #      private_key = file(var.private_key_path)
  #      host  = self.network_interface[0].nat_ip_address
  #      agent = false
  #    }
  #  }
  depends_on = []
  timeouts {
    create = "10m"
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }
  allow_stopping_for_update = true
}

