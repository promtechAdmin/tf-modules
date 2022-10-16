#output "folder_id" {
#  value = yandex_resourcemanager_folder.folder.id
#}
output "vpc_id" {
  value = yandex_vpc_network.main.id
}

output "public_subnets" {
  value = { for v in yandex_vpc_subnet.public_subnets : v.zone => tomap({
    id=v.id,
    name=v.name,
    zone=v.zone,
    v4_cidr_blocks=v.v4_cidr_blocks
  }) }
}
output "private_subnets" {
  value = { for v in yandex_vpc_subnet.private_subnets : v.zone => tomap({
    id=v.id,
    name=v.name,
    zone=v.zone,
    v4_cidr_blocks=v.v4_cidr_blocks
  }) }
}
