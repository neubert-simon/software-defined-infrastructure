# Register the provider
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  required_version = ">= 0.13"
}

# Configure the Hetzner Cloud API token
provider "hcloud" {
  token = var.hcloud_token
}

# Create the server
resource "hcloud_server" "g01" {
  name         = "g01"
  image        = var.serverImage
  server_type  = var.serverType
  location     = "nbg1"

  # Post server creation init script
  user_data    = file("cloud-init.yaml")
}