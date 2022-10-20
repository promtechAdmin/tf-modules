variable "env" {
  description = "Environment"
  type    = string
  default     = "prod"
}
variable "cluster_env" {
  description = "Cluster Environment"
  type    = string
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
variable "network_id" {
  type    = string
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
variable "instance_name" {
  description = "Instance name"
  type        = string
}
variable "instance_role" {
  description = "Instance role" //ws db as
  type        = string
}
variable "ver_pg" {
  description = "PostgeSQL version"
  type = string
  default = "14C"
}
variable "disk_size" {
  type    = number
  default = 10
}

variable "disk_type" {
  type    = string
  default = "network-ssd"
}
variable "resource_preset_id" {
  type    = string
}
variable "data_lens" {
  type    = string
  default = "false"
}
variable "web_sql" {
  type    = string
  default = "false"
}
variable "serverless" {
  type    = string
  default = "false"
}
variable "data_transfer" {
  type    = string
  default = "false"
}
