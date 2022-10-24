output "compute_instance_group_id" {
  value = yandex_compute_instance_group.instance_group.id
}

output "compute_instance_group_instances" {
  value = {
  for instance in yandex_compute_instance_group.instance_group.instances :
  instance.id => instance.ip_address
  }
}
