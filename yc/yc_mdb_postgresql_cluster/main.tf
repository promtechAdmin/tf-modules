# ==========================
# YC MDB Postgres Resources
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
  security_group_ids=var.security_group_ids
  labels   = var.labels

  config {
    version = var.ver_pg
    resources {
      resource_preset_id = var.resource_preset_id
      disk_type_id = var.disk_type
      disk_size = var.disk_size
    }
    postgresql_config = {
      #Процессор
      autovacuum_max_workers=4 //NCores/4..2 но не меньше 4
      //ssl = off

      #Память
      shared_buffers=1073741824 //RAM/4
      temp_buffers=256000000
      work_mem = 64000000//RAM/32..64 или 32MB..128MB
      maintenance_work_mem = 256000000 //RAM/16..32 или work_mem * 4 или 256MB..4GB
      effective_cache_size = 3221225472//RAM - shared_buffers

      #Диски
      effective_io_concurrency = 2 //(только для Linux систем, не применять для Windows)
      random_page_cost = 1//1.5-2.0 для RAID, 1.1-1.3 для <wbr />SSD, 0.1 для NVMe
      seq_page_cost =1// 0.1 для NVMe дисков
      autovacuum = on
      autovacuum_naptime = 20000
      bgwriter_delay = 20
      bgwriter_lru_multiplier = 4
      bgwriter_lru_maxpages = 400
      synchronous_commit = off
      //checkpoint_segments = //32..256   &lt; 9.5
      checkpoint_completion_target = 0.5//0.5..0.9
      min_wal_size = 1073741824//512MB .. 4G
      max_wal_size = 2147483648//2 * min_wal_size
      //fsync = on
      //commit_delay = 1000
      //commit_siblings = 5
      //temp_tablespaces = 'NAME_OF_TABLESPACE'
      row_security = off
      //max_files_per_process = 1000 (default)

      #Сеть
      max_connections = 200//500..1000

      #Блокировки
      max_locks_per_transaction = 256

      #Настройки под платформу 1С
      standard_conforming_strings = off
      escape_string_warning = off
      plantuner_fix_empty_table=on
      //shared_preload_libraries = 'online_analyze, plantuner'
      online_analyze.enable = on

      #Оптимизатор
#      default_statistics_target = 1000 -10000
#      enable_nestloop=off, enable_mergejoin=off
#      join_collapse_limit=1
#      from_collapse_limit = 20
#      online_analyze.table_type = "all"
#      online_analyze.threshold = 50
#      online_analyze.scale_factor = 0.1
#      online_analyze.min_interval = 10000
#      online_analyze.local_tracking = off
#      online_analyze.verbose = 'off'
#      plantuner.fix_empty_table = 'on'

    }

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
  name = var.cluster_user
  password = var.cluster_user_pass
}

resource "yandex_mdb_postgresql_database" "pg_db" {
  count    = length(var.pg_db_names)
  cluster_id = yandex_mdb_postgresql_cluster.pg_cluster.id
  name       = element(var.pg_db_names,count.index)
  owner      = yandex_mdb_postgresql_user.pg_user.name
  lc_collate = "ru_RU.UTF-8"
  lc_type    = "ru_RU.UTF-8"
}