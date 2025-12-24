# modules/app/variables.tf

variable "container_name" {
  description = "Name for the application container."
  type        = string
}
variable "module_count" {
  description = "Number of Nginx containers to deploy"
  type        = number
  default     = 1
}

variable "image_tag" {
  description = "The Docker image tag for the application (Node.js or Python app)."
  type        = string
}

variable "image_digest" {
  description = "The Docker image digest for the application (Node.js or Python app)."
  type        = string
  default     = "app@sha256:64141b4e9fc6050e25220322b13ae96f294761725489617e4dd315a7971a07ba"
}

variable "network_name" {
  description = "The name of the custom Docker network to attach the app to."
  type        = string
}

variable "external_port" {
  description = "The host port to expose the application on."
  type        = number
}

variable "internal_port" {
  description = "The port the application listens on inside the container."
  type        = number
}

variable "environment_vars" {
  description = "A map of key/value pairs for container environment variables."
  type        = map(string)
  default     = {}
}
# variables to ADD to modules/app/variables.tf

variable "db_user" {
  description = "The username to connect to the database."
  type        = string
}

variable "db_password" {
  description = "The password for the database user."
  type        = string
  sensitive   = true 
}

variable "db_host" {
  description = "The name of the database schema to connect to."
  type        = string
}

variable "db_name" {
  description = "The name of the database schema to connect to."
  type        = string
}

variable "instance_id" {
  type        = number
  description = "The index from the root module count"
}
