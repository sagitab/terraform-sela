terraform {
  required_version = ">= 1.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  alias = "root_docker"
}

# Deploy first Nginx container
module "web1" {
  source = "./modules/web"

  container_name = "nginx1"
  external_port  = 8081
  image_tag      = "nginx:latest"
}

