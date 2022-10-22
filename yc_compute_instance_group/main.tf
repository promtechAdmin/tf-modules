terraform {
  required_version = ">= 0.13"

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

resource "yandex_compute_instance_group" "instance_group" {
  name                = var.instance_group_name
  folder_id           = var.folder_id
  service_account_id  = var.service_account_id
  deletion_protection = var.deletion_protection
  instance_template {
    name        = "${var.env}-s${var.instance_role}-${var.instance_name}"
    #platform_id = lookup(var.instance_platform,var.env)
    platform_id = var.instance_platform
    hostname    = "${var.env}-s${var.instance_role}-${var.instance_name}.${var.domain_fqdn}"

    labels = local.labels

    resources {
      core_fraction = var.core_fraction
      cores         = var.cores
      memory        = var.memory

    }
    boot_disk {
      initialize_params {
        image_id = data.yandex_compute_image.ubuntu.id
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
      subnet_ids          = var.subnet_ids
      nat                = var.is_nat
      nat_ip_address     = var.nat_ip_address
      ip_address         = var.ip_address
      security_group_ids = var.security_group_ids
      ipv6               = false
    }
    scheduling_policy {
      preemptible = var.is_preemptible
    }
    metadata = {
      user-data          = var.user_data
      serial-port-enable = 1
    }
  }

  scale_policy {
    fixed_scale {
      size = var.size
    }
#    auto_scale {
#      initial_size           = var.initial_size
#      measurement_duration   = var.measurement_duration
#      cpu_utilization_target = var.cpu_utilization_target
#      warmup_duration        = var.warmup_duration
#      stabilization_duration = var.stabilization_duration
#    }
  }

  allocation_policy {
    zones = var.ig_zones
  }

  deploy_policy {
    max_unavailable  = var.max_unavailable
    max_creating     = var.max_creating
    max_expansion    = var.max_expansion
    max_deleting     = var.max_deleting
    startup_duration = var.startup_duration
    strategy         = var.strategy
  }

  labels = local.labels
  depends_on = []
  timeouts {
    create = "10m"
  }
  lifecycle {
    create_before_destroy = true
  }

}

