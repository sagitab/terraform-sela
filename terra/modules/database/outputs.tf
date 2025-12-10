# modules/db/outputs.tf

output "container_id" {
  description = "The ID of the database container."
  value       = docker_container.db.id
}

output "internal_ip" {
  description = "The internal Docker network IP of the database container."
  # Use the reliable network_data attribute
  value       = docker_container.db.network_data[0].ip_address
}

output "internal_port" {
  description = "The default internal port for PostgreSQL/MySQL (5432 or 3306)."
  value       = 5432 # Default PostgreSQL port
}

output "db_user" {
  description = "The database user name (non-sensitive)."
  value       = var.db_user
}