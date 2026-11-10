# Register the provider
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    local = {
      source = "hashicorp/local"
    }
  }
  required_version = ">= 1.5"
}

# Configure the Hetzner Cloud API token
variable "hcloud_token" {
  description = "Hetzner API token"
  type        = string
  nullable    = false
  sensitive   = true
}

provider "hcloud" {
  token = var.hcloud_token
}

# Load the common configuration
module "config" {
  source = "../Modules/Conf"
}

# Set up SSH keys
resource "hcloud_ssh_key" "sshKeys" {
  for_each   = module.config.authorizedKeys
  name       = each.key
  public_key = each.value
}