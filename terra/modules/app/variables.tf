# modules/app/variables.tf

variable "container_name" {
  description = "Name for the application container."
  type        = string
}

variable "image_tag" {
  description = "The Docker image tag for the application (Node.js or Python app)."
  type        = string
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