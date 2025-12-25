# main.tf (for the 'app' module)
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

# 1. Always look up the latest image info
data "docker_image" "app_data" {
  name = "app:v1"
}

# ----------------------------------------------------
# 1. Image Resource (Your Application Image)
# ----------------------------------------------------
resource "docker_image" "app" {
  # This should reference the image that contains your Flask application
  # For example: "sagisen/whether_api:latest"
  name         = var.image_digest
  keep_locally = true # Keep the image even after 'terraform destroy'
}

# ----------------------------------------------------
# 2. Container Resource (The Flask App)
# ----------------------------------------------------
resource "docker_container" "app" {
  count = var.module_count
  name  = "${var.container_name}-${var.instance_id + 1}"
  image = docker_image.app.name

  # Ensure the container is restarted if it stops unexpectedly
  restart = "unless-stopped"

  # Map the internal application port (5000) to an external port
  # so you can access the app from your host machine (e.g., http://localhost:8888)
  ports {
    internal = var.internal_port # 5000 (from your app.run)
    external = var.external_port + var.instance_id + local.staging_bonus + local.prod_bonus
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
  #provisioner "local-exec" {
    # This runs: ./health.sh dev (or prod/staging)
    #command = "sh ./health_script.sh ${terraform.workspace} ${self.ports[0].external}"
  #}

  # Ensure the DB container is ready before attempting to create the app container
  # This reduces connection errors on initial deployment.
  # need to add depend on
}

resource "null_resource" "health_check" {
  # Match the count of the app containers
  count = var.module_count

  triggers = {
    # Reference 'docker_container.app' and use [count.index]
    container_id = docker_container.app[count.index].id
    script_hash  = filemd5("health_script.sh")
  }

  provisioner "local-exec" {
    # Access the specific external port for THIS instance
    command = "sh ./health_script.sh ${terraform.workspace} ${docker_container.app[count.index].ports[0].external}"
  }
}
