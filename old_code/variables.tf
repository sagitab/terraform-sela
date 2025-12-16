# modules/db/variables.tf

variable "db_name" {
  description = "The name for the database service container."
  type        = string
}

variable "image_tag" {
  description = "The Docker image tag for the database (e.g., postgres:latest)."
  type        = string
}

variable "network_name" {
  description = "The name of the custom Docker network to attach the DB to."
  type        = string
}

variable "db_user" {
  description = "The PostgreSQL/MySQL database user name."
  type        = string
}

variable "db_password" {
  description = "The PostgreSQL/MySQL database password."
  type        = string
  sensitive   = true # Mark password as sensitive
}

variable "db_schema" {
  description = "The initial schema name to create (e.g., my_app_db)."
  type        = string
}