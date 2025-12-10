output "container_ids" {
  description = "IDs of all Nginx containers"
  value       = docker_container.nginx[*].id
}

output "container_names" {
  description = "Names of all Nginx containers"
  value       = docker_container.nginx[*].name
}

output "exposed_ports" {
  description = "Exposed host ports of all Nginx containers"
  value       = docker_container.nginx[*].ports[*].external
}

output "container_ips" {
  value= docker_container.nginx[*].network_data[0].ip_address  
}

