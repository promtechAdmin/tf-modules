output "instance_name" {
  value=yandex_compute_instance.server.*.fqdn
}
output "instance_internal_ip" {
  value=yandex_compute_instance.server.*.network_interface.0.ip_address
}
output "instance_external_ip" {
  value=yandex_compute_instance.server.*.network_interface.0.nat_ip_address
}
output "instance_labels" {
  value=yandex_compute_instance.server.*.labels
}
