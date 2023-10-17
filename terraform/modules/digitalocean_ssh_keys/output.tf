output "personal_fingerprint" {
  value = digitalocean_ssh_key.personal_rink.fingerprint
}

output "deploy_fingerprint" {
  value = digitalocean_ssh_key.deploy_rink.fingerprint
}
