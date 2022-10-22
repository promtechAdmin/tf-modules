terraform {
  required_version = ">= 0.13"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }

  }
}

#----------------------------------------------------------
#  Provision:
#  - Folder
#  - VPC
#  - Internet Gateway
#  - XX Public Subnets
#  - XX Private Subnets
#  - XX NAT Gateways in Public Subnets to give access to Internet from Private Subnets
#
#
#----------------------------------------------------------

#==============================================================

#resource "yandex_resourcemanager_folder" "folder" {
#  name = var.folder_name
#}
locals{
  project=var.labels.project
}

resource "yandex_vpc_network" "main" {
  name = "${var.env}-vpc-${local.project}"
  description = var.vpc_description
  labels=var.labels
}

#-------------Public Subnets and Routing----------------------------------------
resource "yandex_vpc_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  name = "${var.env}-${var.public_subnet_cidrs[count.index].name}${count.index + 1}"
  network_id                  = yandex_vpc_network.main.id
//  v4_cidr_blocks              = [element(var.public_subnet_cidrs, count.index)]
  v4_cidr_blocks = [var.public_subnet_cidrs[count.index].prefix]
  zone       = var.public_subnet_cidrs[count.index].zone
  route_table_id  =yandex_vpc_route_table.public_subnet_rt[count.index].id
  labels=var.labels
  depends_on = [yandex_vpc_network.main, yandex_vpc_route_table.public_subnet_rt]
}

resource "yandex_vpc_route_table" "public_subnet_rt" {
  count  = length(var.public_subnet_cidrs)
  network_id  = yandex_vpc_network.main.id
  name = "${var.env}-public_subnet_rt${count.index + 1}"
  labels=var.labels

  static_route {
    destination_prefix  = "0.0.0.0/0"
    next_hop_address         = var.vpn_gateway_address
  }
  depends_on = [yandex_vpc_gateway.egress-gateway]
}

#--------------NAT Gateway------------------------

resource "yandex_vpc_gateway" "egress-gateway" {
  name = "egress-gateway"
  shared_egress_gateway {}
}

#--------------Private Subnets and Routing-------------------------

resource "yandex_vpc_subnet" "private_subnets" {
  count           = length(var.private_subnet_cidrs)
  name            = "${var.env}-${var.private_subnet_cidrs[count.index].name}${count.index + 1}"
  network_id      = yandex_vpc_network.main.id
//  v4_cidr_blocks              = [element(var.private_subnet_cidrs, count.index)]
  v4_cidr_blocks  = [var.private_subnet_cidrs[count.index].prefix]
  zone            = var.public_subnet_cidrs[count.index].zone
  labels          =var.labels
  route_table_id  =yandex_vpc_route_table.private_subnet_rt[count.index].id
  depends_on = [yandex_vpc_network.main,yandex_vpc_route_table.private_subnet_rt]
}

resource "yandex_vpc_route_table" "private_subnet_rt" {
  count  = length(var.private_subnet_cidrs)
  network_id  = yandex_vpc_network.main.id
  name = "${var.env}-private_subnet_rt${count.index + 1}"
  labels=var.labels

  static_route {
    destination_prefix = var.vpn_client_cidrs
    next_hop_address   = var.vpn_gateway_address
  }

  static_route {
    destination_prefix  = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.egress-gateway.id
  }
  depends_on = [yandex_vpc_gateway.egress-gateway]
}


#==============================================================