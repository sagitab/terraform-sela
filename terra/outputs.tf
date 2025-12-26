
output "automation_summary" {
  description = "Unified JSON-formatted summary for automation tools"
  value = {
    metadata = {
      workspace = terraform.workspace
      timestamp = timestamp()
    }
    infrastructure = {
      network_id = data.docker_network.dev_net.id
    }
    # Web Layer (Nginx)
    web_layer = {
      ids   = [for c in module.web : c.container_ids]
      names = [for c in module.web : c.container_names]
      ports = [for c in module.web : c.exposed_ports]
      ips   = [for c in module.web : c.container_ips]
    }
  }
}

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

/*
output "web_container_ids" {
  description = "IDs of all Nginx containers"
  value       = [for c in module.web : c.container_ids]
}

output "web_container_names" {
  description = "Names of all Nginx containers"
  value       = [for c in module.web : c.container_names]
}

output "web_exposed_ports" {
  description = "Exposed host ports of all Nginx containers"
  value       = [for c in module.web : c.exposed_ports]
}

output "web_container_ips" {
  description = "Internal Docker network IPs of all Nginx containers"
  value       = [for c in module.web : c.container_ips]
}
*/