variable "env" {
  description = "Environment"
  type    = string
  default     = "prod"
}
variable "network_id" {
  type    = string
}

variable "allow_ports" {
  type    = map
  default = {
    "prod"= []
    "test"= []
    "dev"=["22"]
  }
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
