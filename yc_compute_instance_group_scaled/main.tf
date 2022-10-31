terraform {
  required_version = ">= 0.13"

  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}
module "compute_instance_group_scaled" {
  source = "git@github.com:promtechAdmin/tf-modules.git//yc_compute_instance_group"
  scale_policy {
    auto_scale {
      initial_size           = var.initial_size
      measurement_duration   = var.measurement_duration
      cpu_utilization_target = var.cpu_utilization_target
      warmup_duration        = var.warmup_duration
      stabilization_duration = var.stabilization_duration
      min_zone_size = var.min_zone_size
      max_size = var.max_size
    }
  }
}
