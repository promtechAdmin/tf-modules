
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
variable "min_zone_size" {
  type    = number
  default = 1
}
variable "max_size" {
  type    = number
  default = 2
}
