# modules/db/outputs.tf

# Output the container name so the app module can use it as DB_HOST
output "db_host_name" {
  description = "The network hostname (container name) of the database service."
  value       = docker_container.db.name
}

# Output the DB network port (standard for MySQL)
output "db_internal_port" {
  description = "The internal port of the database container."
  value       = 3306 
}