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
