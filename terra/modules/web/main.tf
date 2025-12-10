terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}
resource "docker_image" "nginx" {
  name         = var.image_tag
  force_remove = true
}

resource "docker_container" "nginx" {
  count = var.instance_count

  name  = "${var.container_name}-${count.index + 1}"
  image = docker_image.nginx.name

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 80
    external = var.external_port + count.index
  }

  restart = "unless-stopped"
}
