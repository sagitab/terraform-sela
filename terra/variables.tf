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

# Root level variables.tf

variable "db_user" {
  description = "The database connection username."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The database connection password."
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "The database hostname or service name."
  type        = string
}
variable "db_name" {
  description = "The database hostname or service name."
  type        = string
  default     = "flask_db"
}
