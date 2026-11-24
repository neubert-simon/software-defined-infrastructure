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

provider "hcloud" { token = var.hcloud_token }

# Load the common configuration
module "config" { source = "../Conf" }

resource "hcloud_ssh_key" "sshKeys" {
  for_each   = module.config.authorizedKeys
  name       = each.key
  public_key = each.value
}