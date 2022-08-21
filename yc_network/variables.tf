variable "count_static_ips"{
  type =number
  default =0
}
variable "folder_name"{
  type =string
}

variable "zone" {
  type =string
  default = "ru-central1-a"
}

variable "env" {
  description = "Environment"
  type    = string
  default     = "prod"
}
variable "gateway-addresses" {
  default = [
    "10.0.11.1",
    "10.0.22.1",
    "10.0.33.1"
  ]
}
variable "public_subnet_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}

variable "private_subnet_cidrs" {
  default = [
    "10.0.11.0/24",
    "10.0.22.0/24",
    "10.0.33.0/24"
  ]
}
variable "labels" {
  type    = map
  default = {
    owner = ""
    project = ""
    cost_center=""
    environment=""
  }
}