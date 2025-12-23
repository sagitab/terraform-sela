terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}

locals {
    # IF workspace is staging prot 8898 and if prod the port is 8908
  staging_bonus = terraform.workspace == "staging" ? 10 : 0
  prod_bonus = terraform.workspace == "prod" ? 20 : 0
}

resource "docker_image" "nginx" {
  name         = "nginx@sha256:fb01117203ff38c2f9af91db1a7409459182a37c87cced5cb442d1d8fcc66d19"
  force_remove = true
}

resource "docker_container" "nginx" {
  name  = "${var.container_name}-${var.instance_id + 1}"
  image = docker_image.nginx.name

  networks_advanced {
    name = var.network_name
  }


  ports {
    internal = 80
    external = var.external_port + var.instance_id + local.staging_bonus + local.prod_bonus
  }

  restart = "unless-stopped"
}
