output "mdb_postgresql_cluster_id" {
  value=yandex_mdb_postgresql_cluster.pg_cluster.id
}
output "mdb_postgresql_cluster_host_fqdn" {
  value=yandex_mdb_postgresql_cluster.pg_cluster.host.0.fqdn
}
output "mdb_postgresql_cluster_user" {
  value=yandex_mdb_postgresql_user.pg_user
}
output "mdb_postgresql_cluster_db" {
  value=yandex_mdb_postgresql_database.pg_db.*
}
