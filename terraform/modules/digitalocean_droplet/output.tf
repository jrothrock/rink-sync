output "droplet_id" {
  value = digitalocean_droplet.rink.id
}

output "droplet_ipv4" {
  value = digitalocean_droplet.rink.ipv4_address
}
