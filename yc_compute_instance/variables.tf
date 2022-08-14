variable "env" {
  description = "Environment"
  type    = string
  default     = "prod"
}
variable "network_id" {
  type    = string
}
variable "subnet_id" {
  type    = string
}
variable "security_group_ids" {
  type    = list(string)
  default =[""]
}
variable "folder_id" {
  type    = string
}
variable "zone" {
  type    = string
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

variable "nat" {
  type    = bool
  default = true
}

variable "image_family" {
  type    = string
  default = "ubuntu-2004-lts"
}

variable "public_key_path" {
  description = "Path to ssh public key, which would be used to access workers"
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to ssh private key, which would be used to access workers"
  default     = "~/.ssh/id_rsa"
}
variable "instance_count" {
  type    = number
  default = 1
}

variable "instance_name" {
  type = string
}

variable "core_fraction" {
  type    = number
  default = 50
}
variable "cores" {
  type    = number
  default = 2
}

variable "instance_type" {
  description = "instance types"
  type    = map
  default     = {
    "prod" = "standard-v2"
    "test" = "standard-v2"
    "dev" = "standard-v2"
  }
}

variable "memory" {
  type    = number
  default = 2
}

variable "disk_size" {
  type    = number
  default = 10
}

variable "disk_type" {
  type    = string
  default = "network-ssd"
}

variable "user_password" {
  type = string
}
variable "openvpn_password" {
  type = string
}

variable "user" {
  type    = string
  default = ""
}
variable "instance_init_script" {
  type    = list(string)
  default = [""]
}


#variable "admin_pass" {
#  default = ""
#  type    = string
#}