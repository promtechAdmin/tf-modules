variable "env" {
  description = "Environment"
  type    = string
  default     = "prod"
}
variable "subnet_id" {
  type    = string
}
variable "security_group_ids" {
  type    = list(string)
  default =[]
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

variable "is_nat" {
  description = "Provide a public address for instance to access the internet over NAT"
  type        = bool
  default     = false
}

variable "nat_ip_address" {
  description = "Public IP address for instance to access the internet over NAT"
  type        = string
  default     = ""
}

variable "ip_address" {
  description = "The private IP address to assign to the instance. If empty, the address will be automatically assigned from the specified subnet"
  type        = string
  default     = ""
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
  description = "Yandex Cloud Compute instance name"
  type        = string
}

# The hostname must be unique within the network and region
# If not specified, the host name will be equal to id of the instance and fqdn will be <id>.auto.internal
# Otherwise FQDN will be <hostname>.<region_id>.internal
variable "hostname" {
  description = "Host name for the instance. This field is used to generate the instance fqdn value"
  type        = string
  default =""
}

variable "cores" {
  description = "CPU cores for the instance"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory size for the instance in GB"
  type        = number
  default     = 2
}

variable "core_fraction" {
  description = "Baseline performance for a core as a percent"
  type        = number
  default     = 50
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

variable "disk_size" {
  type    = number
  default = 10
}
variable "secondary_disk_size" {
  type    = number
  default = 10
}

variable "disk_type" {
  type    = string
  default = "network-ssd"
}
variable "secondary_disk_names" {
  type    = list(string)
  default = []
}

variable "user_password" {
  type = string
}

variable "user_login" {
  type    = string
  default = ""
}
variable "instance_init_script" {
  type    = list(string)
  default = []
}


#variable "admin_pass" {
#  default = ""
#  type    = string
#}