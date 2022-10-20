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
  name        = "${var.env}-cluster${var.instance_role}-${var.instance_name}"
  environment = var.cluster_env
  network_id = var.network_id
  labels   = var.labels
  config {
    version = var.ver_pg
    resources {
      resource_preset_id = var.resource_preset_id
      disk_type_id = var.disk_type
      disk_size = var.disk_size
    }
#    postgresql_config = {
#      max_connections                   = 500
#      enable_parallel_hash              = true
#      vacuum_cleanup_index_scale_factor = 0.2
#      autovacuum_vacuum_scale_factor    = 0.34
#      default_transaction_isolation     = "TRANSACTION_ISOLATION_READ_COMMITTED"
#      shared_preload_libraries          = "SHARED_PRELOAD_LIBRARIES_AUTO_EXPLAIN,SHARED_PRELOAD_LIBRARIES_PG_HINT_PLAN"
#    }
    access {
      data_lens=var.data_lens
      web_sql=var.web_sql
      serverless=var.serverless
      data_transfer=var.data_transfer
    }
    performance_diagnostics {
      enabled="true"
      sessions_sampling_interval = "10"
    statements_sampling_interval="600"

  }
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "SAT"
    hour = 12
  }
  host {
    zone = var.zone
    subnet_id = var.subnet_id
    #name =""
  }
  deletion_protection=true
}

resource "yandex_mdb_postgresql_user" "pg_user" {
  cluster_id = yandex_mdb_postgresql_cluster.pg_cluster.id
  name = var.pg_db_user
  password = var.pg_db_pass
}

resource "yandex_mdb_postgresql_database" "pg_db" {
  count    = length(var.pg_db_names)
  cluster_id = yandex_mdb_postgresql_cluster.pg_cluster.id
  name       = element(var.pg_db_names,count.index)
  owner      = yandex_mdb_postgresql_user.pg_user.name
  lc_collate = "ru_RU.UTF-8"
  lc_type    = "ru_RU.UTF-8"
}