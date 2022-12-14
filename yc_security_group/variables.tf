variable "env" {
  description = "Environment"
  type    = string
  default     = "prod"
}
variable "name" {
  type    = string
}
variable "description" {
  type    = string
  default =""
}
variable "network_id" {
  type    = string
}

variable "allow_tcp_ports" {

}
variable "allow_udp_ports" {

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
