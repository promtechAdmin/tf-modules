# ==========================
# YC MDB Postgress Resources
# ==========================
terraform {
  required_version = ">= 0.13"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
  }
}
locals{
  labels = merge(var.labels,{name="${var.env}_${var.instance_name}"})
}
resource "yandex_mdb_postgresql_cluster" "pg_cluster" {
  name        = "${var.env}-cluster${var.instance_role}-${var.instance_name}.${var.domain_fqdn}"
//  environment = "PRODUCTION"
  network_id = var.network_id
  labels   = local.labels
  config {
    version = var.ver_pg
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id = "network-ssd"
      disk_size = 20
    }
  }

  host {
    zone = var.zone
    subnet_id = var.subnet_id
  }
}

resource "yandex_mdb_postgresql_user" "pg_user" {
  cluster_id = yandex_mdb_postgresql_cluster.pg_cluster.id
  name = var.pg_db_user
  password = var.pg_db_pass
}

#resource "yandex_mdb_postgresql_database" "pg_db" {
#  cluster_id = yandex_mdb_postgresql_cluster.pg_cluster.id
#  name       = var.pg_db_name
#  owner      = yandex_mdb_postgresql_user.pg_user.name
#  lc_collate = "en_US.UTF-8"
#  lc_type    = "en_US.UTF-8"
#}