# modules/db/variables.tf

variable "db_name" {
  description = "The name for the database service container (used as the network hostname)."
  type        = string
}
variable "module_count" {
  description = "Number of Nginx containers to deploy"
  type        = number
  default     = 1
}
variable "image_tag" {
  description = "The Docker image tag for the database (e.g., mysql:8.0)."
  type        = string
}

variable "image_digest" {
  description = "The Docker image digest for the application (Node.js or Python app)."
  type        = string
  default     = "mysql@sha256:0275a35e79c60caae68fac520602d9f6897feb9b0941a1471196b1a01760e581"
}


variable "network_name" {
  description = "The name of the custom Docker network to attach the DB to."
  type        = string
}

variable "db_user" {
  description = "The MySQL database user name."
  type        = string
}

variable "db_password" {
  description = "The MySQL database password."
  type        = string
  sensitive   = true # Mark password as sensitive
}

variable "db_schema" {
  description = "The initial schema name to create."
  type        = string
}

variable "container_name" {
  description = "The prefix for the database container name"
  type        = string
}

variable "db_port" {
  description = "database port"
  type        = number
  default     = 3306
}
