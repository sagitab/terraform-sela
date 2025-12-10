# modules/db/main.tf
# modules/app/main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}
# 1. Docker Volume for Data Persistence
# This ensures data persists even if the container is destroyed and recreated.
resource "docker_volume" "db_data" {
  name = "${var.db_name}-data"
}

# 2. Docker Image
resource "docker_image" "db" {
  name         = var.image_tag
  force_remove = true
}

# 3. Database Container Deployment (PostgreSQL Example)
resource "docker_container" "db" {
  name  = var.db_name
  image = docker_image.db.name

  # Security: Expose ONLY to internal network
  # No 'ports' block is used, so no host ports are exposed.
  networks_advanced {
    name = var.network_name
  }
  
  # Environment Variables for Credentials
  # PostgreSQL uses these specific environment variables for configuration
  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_schema}"
  ]

  # Volume: Mount the persistent volume
  volumes {
    # This is the standard data directory for PostgreSQL
    container_path = "/var/lib/postgresql/data" 
    volume_name    = docker_volume.db_data.name
  }
  
  restart = "unless-stopped"
}