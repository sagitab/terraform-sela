# modules/app/outputs.tf

output "container_id" {
  description = "The ID of the application container."
  value       = docker_container.app.id
}

output "container_name" {
  description = "The name of the application container."
  value       = docker_container.app.name
}
