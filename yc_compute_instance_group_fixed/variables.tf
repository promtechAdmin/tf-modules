variable "env" {
  description = "Environment"
  type    = string
  default     = "prod"
}
variable "subnet_ids" {
  type    = list(string)
}
variable "folder_id" {
  type    = string
}
variable "service_account_id" {
  type    = string
}
variable "security_group_ids" {
  type    = list(string)
  default =[]
}

variable "zone" {
  type    = string
}
variable "ig_zones" {
  type    = list(string)
}

variable "domain_fqdn" {
  type    = string
  default = ""
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
  default = "ubuntu-2204-lts"
}

#variable "public_key_path" {
#  description = "Path to ssh public key, which would be used to access workers"
#  default     = "~/.ssh/id_rsa.pub"
#}
#
#variable "private_key_path" {
#  description = "Path to ssh private key, which would be used to access workers"
#  default     = "~/.ssh/id_rsa"
#}
variable "instance_count" {
  type    = number
  default = 1
}

variable "instance_name" {
  description = "Instance name"
  type        = string
  default = ""
}

variable "instance_role" {
  description = "Instance role" //ws db as
  type        = string
  default = "as"
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

#variable "instance_platform" {
#  description = "instance platform"
#  type    = map
#  default     = {
#    "prod" = "standard-v2"
#    "test" = "standard-v2"
#    "dev" = "standard-v2"
#  }
#}
variable "instance_platform" {
  type = string
  default = "standard-v2"
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
variable "is_preemptible" {
  type    = bool
  default = false
}
variable "is_fixed_scale" {
  type    = bool
  default = true
}
variable "secondary_disk_names" {
  type    = list(string)
  default = []
}

#variable "user_password" {
#  type = string
#}
#
#variable "user_login" {
#  type    = string
#  default = ""
#}
variable "instance_init_script" {
  type    = list(string)
  default = []
}

variable "user_data" {

}
#variable "admin_pass" {
#  default = ""
#  type    = string
#}
variable "max_unavailable" {
  type    = number
  default = 0
}
variable "max_creating" {
  type    = number
  default = 1
}
variable "max_expansion" {
  type    = number
  default =1
}
variable "max_deleting" {
  type    = number
  default = 1
}
variable "startup_duration" {
  type    = number
  default = 30
}
variable "strategy" {
  type    = string
  default = "proactive"
}
variable "size" {
  type    = number
  default = 1
}
variable "initial_size" {
  type    = number
  default = 1
}
variable "measurement_duration" {
  type    = number
  default = 60
}
variable "cpu_utilization_target" {
  type    = number
  default = 80
}
variable "warmup_duration" {
  type    = number
  default = 180
}
variable "stabilization_duration" {
  type    = number
  default = 300
}
variable "deletion_protection" {
  type    = bool
  default = true
}
