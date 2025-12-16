terraform {
  required_version = ">= 1.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
  backend "local" {
    # The path where Terraform will store the state file.
    # The default is "terraform.tfstate" in the current directory.
    # Specifying it explicitly confirms the location.
    path = "terraform.tfstate"
  }
}

provider "docker" {
  alias = "root_docker"
}
resource "docker_network" "custom_net" {
  name = "nginx_network"
}

module "web" {
  source         = "./modules/web"
  instance_count = 3
  container_name = "nginx"
  external_port  = 8081
  network_name   = docker_network.custom_net.name
}
module "app" {
  source = "./modules/app"

  # Configuration determined from the running container:
  container_name = "weather-api"
  image_tag      = "app:v1"
  external_port  = 8888
  internal_port  = 5000

  # Reusing the Docker network defined earlier
  network_name = docker_network.custom_net.name

  # Environment Variables (set to default/empty if not needed)
  environment_vars = {}
  # --- ADDITION TO FIX ERRORS AND PASS SECRETS ---
  # These values come from the .tfvars file, loaded into root variables
  db_user     = var.db_user
  db_password = var.db_password
  db_host     = var.db_host
  db_name     = var.db_name
  depends_on = [
    module.db
  ]
}

module "db" {
  source = "./modules/database"

  # 1. Update the Container Name (now hosting MySQL)
  db_name = "mysql-service"

  # 2. Update the Image Tag to pull a MySQL image
  image_tag = "mysql:8.0"

  # 3. Network remains the same (connecting DB and App)
  network_name = docker_network.custom_net.name

  # 4. Credentials remain the same, as they map correctly to the new
  #    MYSQL_USER, MYSQL_PASSWORD, and MYSQL_DATABASE variables inside the module.
  db_user     = var.db_user
  db_password = var.db_password
  db_schema   = "flask_db"
}