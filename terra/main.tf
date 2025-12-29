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

locals {
  # 1. Configuration Map for each environment
  env_specs = {
    default = { web_replicas = 1, app_replicas = 1, db_replicas = 1 }
    dev     = { web_replicas = 1, app_replicas = 1, db_replicas = 1 }
    staging = { web_replicas = 2, app_replicas = 2, db_replicas = 1 }
    prod    = { web_replicas = 3, app_replicas = 3, db_replicas = 1 }
  }

  # 2. Extract settings for the active workspace (falls back to 'default' if not found)
  settings = lookup(local.env_specs, terraform.workspace, local.env_specs["default"])
  staging_bonus = terraform.workspace == "staging" ? 10 : 0
  prod_bonus = terraform.workspace == "prod" ? 20 : 0
}

provider "docker" {
  alias = "root_docker"
}
# Query the Development network
data "docker_network" "dev_net" {
  name = "network_dev"
}

# Query the Staging network
data "docker_network" "staging_net" {
  name = "network_staging"
}

# Query the Production network
data "docker_network" "prod_net" {
  name = "network_prod"
}

module "web" {
  source = "git::https://github.com/sagitab/terra-module-web.git?ref=v1.0.1"
  container_name = "nginx_${terraform.workspace}"
  count = local.settings.web_replicas
  instance_id    = count.index
  external_port  = 8081
  network_name   = "network_${terraform.workspace}"
}
module "app" {
  source = "./modules/app"
  count = local.settings.app_replicas
  instance_id    = count.index
  # Configuration determined from the running container:
  container_name = "weather-api_${terraform.workspace}"
  image_tag      = "app:v1"
  external_port  = 8888
  internal_port  = 5000

  # Reusing the Docker network defined earlier
  network_name = "network_${terraform.workspace}"

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
  count = local.settings.db_replicas
  container_name = "mysql-${terraform.workspace}"
  # 1. Update the Container Name (now hosting MySQL)
  db_name = "mysql-service"

  # 2. Update the Image Tag to pull a MySQL image
  image_tag = "mysql:8.0"

  # 3. Network remains the same (connecting DB and App)
  network_name = "network_${terraform.workspace}"

  # 4. Credentials remain the same, as they map correctly to the new
  #    MYSQL_USER, MYSQL_PASSWORD, and MYSQL_DATABASE variables inside the module.
  db_user     = var.db_user
  db_password = var.db_password
  db_schema   = "flask_db"
  db_port     = 3306 + local.staging_bonus + local.prod_bonus

}

#resource "docker_container" "monitoring" {
  # IF workspace is prod, count = 1. IF NOT, count = 0 (resource doesn't exist).
#  count = terraform.workspace == "prod" ? 1 : 0
#  name  = "prometheus-prod"
#  image = "prom/prometheus"
#}