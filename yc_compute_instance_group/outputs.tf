output "compute_instance_group_id" {
  value = yandex_compute_instance_group.instance_group.id
}

output "compute_instance_group_instances_name_ip" {
  value = {
  for instance in yandex_compute_instance_group.instance_group.instances :
    instance.name => instance.network_interface.0.ip_address
  }
}
output "load_balancer_target_group_id" {
  value = yandex_compute_instance_group.instance_group.load_balancer.*.target_group_id
}
output "compute_instance_group_instances" {
  value = yandex_compute_instance_group.instance_group.instances
}