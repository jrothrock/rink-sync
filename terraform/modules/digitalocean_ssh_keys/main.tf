terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.17.1"
    }
  }
}

resource "digitalocean_ssh_key" "personal_rink" {
  name       = "Rink Personal SSH Key"
  public_key = file("/Users/jackrothrock/.ssh/rink.pub")
}

resource "digitalocean_ssh_key" "deploy_rink" {
  name       = "Rink Deploy SSH Key"
  public_key = file("/Users/jackrothrock/.ssh/rink.deploy.pub")
}