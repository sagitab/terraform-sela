# variables.tf

variable "container_name" {
  type    = string
  default = "my-nginx"
}

variable "external_port" {
  type    = number
  default = 8081
}

variable "image_tag" {
  type    = string
  default = "nginx:latest"
}
# -----------------
# DB Module Variables
# -----------------

variable "db_user" {
  description = "The database user name for the PostgreSQL container."
  type        = string
}

variable "db_password" {
  description = "The database password for the PostgreSQL container."
  type        = string
  sensitive   = true # Essential: Hides the password in CLI outputs
}