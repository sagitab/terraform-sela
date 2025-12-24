# modules/db/main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}

locals {
  my_db_name = var.db_name
}

# 1. Docker Volume for Data Persistence
# This ensures MySQL data persists across container restarts.
resource "docker_volume" "db_data" {
  name = "${local.my_db_name}-data"
}

# 2. Docker Image
resource "docker_image" "db" {
  # This will pull the tag defined by the root module, e.g., 'mysql:8.0'
  name         = var.image_digest
  force_remove = true
}

# 3. Database Container Deployment (MySQL)
resource "docker_container" "db" {
  name  = "${var.container_name}"
  image = docker_image.db.name

  # Security: Attach to an internal network, preventing external access 
  # unless explicitly mapped in the root configuration.
  networks_advanced {
    name = var.network_name
  }
  
  # Environment Variables for MySQL Initialization
  # These variables tell the official MySQL Docker image how to set up the DB.
# modules/db/main.tf (Cleaned env block)

env = [
    # Required to set the root user password (used by app if DB_USER=root)
    "MYSQL_ROOT_PASSWORD=${var.db_password}", 
    # Required to create the database schema
    "MYSQL_DATABASE=${local.my_db_name}",         
  ]

  # Volume: Mount the persistent volume to the MySQL data directory
  volumes {
    # Standard location for MySQL data files
    container_path = "/var/lib/mysql" 
    volume_name    = docker_volume.db_data.name
  }
  
  restart = "unless-stopped"

}