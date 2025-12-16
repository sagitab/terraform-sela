# main.tf (for the 'app' module)
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6"
    }
  }
}

# ----------------------------------------------------
# 1. Image Resource (Your Application Image)
# ----------------------------------------------------
resource "docker_image" "app" {
  # This should reference the image that contains your Flask application
  # For example: "sagisen/whether_api:latest"
  name         = var.image_tag
  keep_locally = true # Keep the image even after 'terraform destroy'
}

# ----------------------------------------------------
# 2. Container Resource (The Flask App)
# ----------------------------------------------------
resource "docker_container" "app" {
  name  = var.container_name # e.g., "flask-app-service"
  image = docker_image.app.name

  # Ensure the container is restarted if it stops unexpectedly
  restart = "unless-stopped"

  # Map the internal application port (5000) to an external port
  # so you can access the app from your host machine (e.g., http://localhost:8888)
  ports {
    internal = var.internal_port # 5000 (from your app.run)
    external = var.external_port # e.g., 8888
  }

  # Connect to the same Docker network as the database container
  networks_advanced {
    name = var.network_name
  }

  # Environment Variables (CRITICAL for the Python app)
  # These match the os.getenv() calls in your Python code exactly.
  env = [
    "DB_HOST=${var.db_host}",      # The hostname/service name of the DB container
    "DB_USER=${var.db_user}",
    "DB_PASS=${var.db_password}",  # Note the app expects 'DB_PASS'
    "DB_NAME=${var.db_name}",      # Note the app expects 'DB_NAME'
    "FLASK_ENV=development"        # Example Flask environment setting
  ]

  # Ensure the DB container is ready before attempting to create the app container
  # This reduces connection errors on initial deployment.
  # need to add depend on
}