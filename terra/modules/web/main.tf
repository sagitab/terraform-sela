terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}

# Pull the Nginx image
resource "docker_image" "nginx" {
  name = var.image_tag
}

# Run the Nginx container
resource "docker_container" "nginx" {
  name  = var.container_name
  image = docker_image.nginx.name

  ports {
    internal = 80
    external = var.external_port
  }

  restart = "unless-stopped"
}
