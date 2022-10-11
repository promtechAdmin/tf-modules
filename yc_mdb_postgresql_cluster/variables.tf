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
variable "pg_db_name" {
  description = "PostgeSQL cluster and database name"
  type = string
  default = "keycloak"
}

variable "pg_db_user" {
  description = "PostgeSQL database user name"
  type = string
}

variable "pg_db_pass" {
  description = "PostgeSQL database user's password"
  type = string
}
