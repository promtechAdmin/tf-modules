terraform {
  required_version = ">= 0.13"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.47.0"
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

resource "yandex_resourcemanager_folder" "folder" {
  cloud_id = var.folder_name
}
locals{
  project=var.labels.project
}

resource "yandex_vpc_network" "main" {
  Name = "${var.env}-vpc-${local.project}"
  folder_id = yandex_resourcemanager_folder.folder.id
  labels=var.labels
}

#-------------Public Subnets and Routing----------------------------------------
resource "yandex_vpc_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  Name = "${var.env}-public-${count.index + 1}"
  network_id                  = yandex_vpc_network.main.id
  v4_cidr_blocks              = element(var.public_subnet_cidrs, count.index)
  folder_id = yandex_resourcemanager_folder.folder.id
  zone       = var.zone
  labels=var.labels
}

#-----Static Public IPs--------------------------

resource "yandex_vpc_address" "ext_ip" {
  count = var.number_static_ips
  name = "${var.env}-extip-${local.project}-${count.index + 1}"
  folder_id = yandex_resourcemanager_folder.folder.id
  labels=var.labels
  external_ipv4_address {
    zone_id       = var.zone
  }
}

#--------------Private Subnets and Routing-------------------------

resource "yandex_vpc_subnet" "private_subnets" {
  count                   = length(var.private_subnet_cidrs)
  Name = "${var.env}-private-${count.index + 1}"
  network_id                  = yandex_vpc_network.main.id
  v4_cidr_blocks              = element(var.private_subnet_cidrs, count.index)
  folder_id = yandex_resourcemanager_folder.folder.id
  zone       = var.zone
  labels=var.labels
  route_table_id=yandex_vpc_route_table.private_subnets_rt[count.index].id
}

resource "yandex_vpc_route_table" "private_subnets_rt" {
  count  = length(var.private_subnet_cidrs)
  network_id  = yandex_vpc_network.main.id
  Name = "${var.env}-route-private-subnets"
  folder_id = yandex_resourcemanager_folder.folder.id
  labels=var.labels
  static_route {
    destination_prefix  = "0.0.0.0/0"
    next_hop_address    = var.gateway-addresses[count.index]
  }
}


#==============================================================