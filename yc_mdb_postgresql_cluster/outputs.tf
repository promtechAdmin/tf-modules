output "mdb_postgresql_cluster_id" {
  value=yandex_mdb_postgresql_cluster.pg_cluster.id
}
output "mdb_postgresql_cluster_host_fqdn" {
  value=yandex_mdb_postgresql_cluster.pg_cluster.host.*.fqdn
}
