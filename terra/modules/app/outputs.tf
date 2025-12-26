# modules/app/outputs.tf
/*
output "container_id" {
  description = "The ID of the application container."
  value       = docker_container.app.id
}

output "container_name" {
  description = "The name of the application container."
  value       = docker_container.app.name
}
*/

output "container_ips" {
  value = [for c in docker_container.app : c.network_data[0].ip_address]
}