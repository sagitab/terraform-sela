# modules/app/main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}
resource "docker_image" "app" {
  name         = var.image_tag
  force_remove = true
}

resource "docker_container" "app" {
  name  = var.container_name
  image = docker_image.app.name

  # Networking: Connect to the custom network
  networks_advanced {
    name = var.network_name
  }

  # Ports: Map internal application port to external host port
  ports {
    internal = var.internal_port
    external = var.external_port
  }

  # Environment Variables
  # The 'for' expression converts the map(string) variable into the 
  # required list of strings ["KEY=VALUE", "KEY2=VALUE2"] format.
  env = [
    for k, v in var.environment_vars : "${k}=${v}"
  ]

  # Health Check Implementation
  healthcheck {
    # Check command: Use CMD-SHELL to run a curl command against the internal port
    test = ["CMD-SHELL", "curl --fail http://localhost:${var.internal_port}/health || exit 1"]
    interval = "10s"
    timeout  = "3s"
    retries  = 3
    start_period = "5s" # Give the app 5 seconds to start up before checking
  }

  restart = "unless-stopped"
}