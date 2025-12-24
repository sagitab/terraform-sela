variable "module_count" {
  description = "Number of Nginx containers to deploy"
  type        = number
  default     = 1
}

variable "container_name" {
  description = "Base name of the Nginx container(s)"
  type        = string
}

variable "external_port" {
  description = "Host port for the first container (subsequent containers increment this port)"
  type        = number
}

variable "image_tag" {
  description = "Docker image tag to use for Nginx"
  type        = string
  default     = "nginx:latest"
}

variable "image_digest" {
  description = "The Docker image digest for the application (Node.js or Python app)."
  type        = string
  default     = "nginx@sha256:fb01117203ff38c2f9af91db1a7409459182a37c87cced5cb442d1d8fcc66d19"
}

variable "network_name" {
  description = "Docker network name to attach the containers to"
  type        = string
  default     = "bridge"
}

variable "instance_id" {
  type        = number
  description = "The index from the root module count"
}