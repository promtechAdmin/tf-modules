output "instance_name" {
  value=yandex_compute_instance.server.*.fqdn
}
output "instance_internal_ip" {
  value=yandex_compute_instance.server.*.network_interface.0.ip_address
}
output "instance_external_ip" {
  value=yandex_compute_instance.server.*.network_interface.0.nat_ip_address
}
output "boot_disk_id" {
  value=yandex_compute_instance.server.*.boot_disk.*.disk_id
}
output "instance_labels" {
  value=yandex_compute_instance.server.*.labels
}
output "secondary_disks" {
  value=yandex_compute_disk.secondary_disk.*.id
}
