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
