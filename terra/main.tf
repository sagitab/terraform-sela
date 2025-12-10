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
resource "docker_network" "custom_net" {
  name = "nginx_network"
}

module "web" {
  source = "./modules/web"
  instance_count = 3
  container_name = "nginx"
  external_port  = 8081
   network_name   = docker_network.custom_net.name
}
module "app" {
  source           = "./modules/app"
  
  # Configuration determined from the running container:
  container_name   = "weather-api"
  image_tag        = "sagisen/whether_api:latest"
  external_port    = 8888
  internal_port    = 5000 
  
  # Reusing the Docker network defined earlier
  network_name     = docker_network.custom_net.name 
  
  # Environment Variables (set to default/empty if not needed)
  environment_vars = {} 
}
# terra/main.tf (Append this to your existing file)

module "db" {
  source       = "./modules/database"

  db_name      = "postgresql-db"
  image_tag    = "postgres:14-alpine" 
  network_name = docker_network.custom_net.name

  # Credentials (IMPORTANT: Never hardcode sensitive values in code like this 
  # in a production environment; use TF_VAR environment variables or a secrets manager.)
  db_user      = var.db_user
  db_password  = var.db_password
  db_schema    = "app_database"
}
