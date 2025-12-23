#output "web_container_ids" {
#  description = "IDs of all Nginx containers"
#  value       = module.web.container_ids
#}

#output "web_container_names" {
#  description = "Names of all Nginx containers"
#  value       = module.web.container_names
#}

#output "web_exposed_ports" {
#  description = "Exposed host ports of all Nginx containers"
#  value       = module.web.exposed_ports
#}

#output "web_container_ips" {
#  description = "Internal Docker network IPs of all Nginx containers"
#  value       = module.web.container_ips
#}

data "docker_network" "dev" {
  name = "network_dev"
}

output "dev_network_details" {
  value = {
    id     = data.docker_network.dev.id
    # We use tolist() to fix the "Invalid index" error
    subnet = tolist(data.docker_network.dev.ipam_config)[0].subnet
  }
}