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