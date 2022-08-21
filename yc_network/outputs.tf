#output "folder_id" {
#  value = yandex_resourcemanager_folder.folder.id
#}
output "vpc_id" {
  value = yandex_vpc_network.main.id
}

output "public_subnet_ids" {
  value = yandex_vpc_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = yandex_vpc_subnet.private_subnets[*].id
}
output "external_ips" {
  value = yandex_vpc_address.ext_ip[*].id
}
output "public_subnets" {
  value = { for v in yandex_vpc_subnet.public_subnets : v.zone => tomap({
    "id", v.id,
    "name", v.name,
    "zone", v.zone
  }) }
}
output "private_subnets" {
  value = { for v in yandex_vpc_subnet.private_subnets : v.zone => tomap({
    "id", v.id,
    "name", v.name,
    "zone", v.zone
  }) }
}