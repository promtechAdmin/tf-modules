variable "count_static_ips"{
  type =number
  default =0
}
variable "folder_name"{
  type =string
  default=""
}

variable "zone" {
  type =string
  default = "ru-central1-a"
}
variable "description" {
  type =string
  default = ""
}

variable "env" {
  description = "Environment"
  type    = string
  default     = "prod"
}
variable "gateway-address" {
  type= string
}
variable "public_subnet_cidrs" {
  description = "Subnet structure primitive"
  type = list(object({
    name = string,
    zone = string,
    prefix = string
  }))

  default = [
    { name = "public-subnet-a", zone = "ru-central1-a", prefix = "10.0.1.0/24" },
    { name = "public-subnet-b", zone = "ru-central1-b", prefix = "10.0.2.0/24" },
    { name = "public-subnet-c", zone = "ru-central1-c", prefix = "10.0.3.0/24" },
  ]


}

variable "private_subnet_cidrs" {
  description = "Subnet structure primitive"
  type = list(object({
    name = string,
    zone = string,
    prefix = string
  }))

  default = [
    { name = "private-subnet-a", zone = "ru-central1-a", prefix = "10.0.1.0/24" },
    { name = "private-subnet-b", zone = "ru-central1-b", prefix = "10.0.2.0/24" },
    { name = "private-subnet-c", zone = "ru-central1-c", prefix = "10.0.3.0/24" },
  ]

#  validation {
#    condition = length(var.public_subnet_cidrs) >= 1
#    error_message = "At least one Subnet/Zone should be used."
#  }
}
#variable "public_subnet_cidrs" {
#  type= list(string)
#  default = [
#    "10.0.1.0/24",
#    "10.0.2.0/24",
#    "10.0.3.0/24"
#  ]
#}
#
#variable "private_subnet_cidrs" {
#  type= list(string)
#  default = [
#    "10.0.11.0/24",
#    "10.0.22.0/24",
#    "10.0.33.0/24"
#  ]
#}
variable "labels" {
  type    = map
  default = {
    owner = ""
    project = ""
    cost_center=""
    environment=""
  }
}