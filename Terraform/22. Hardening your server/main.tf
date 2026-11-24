#region Server
module "server" {
  source = "../Modules/Server"
}

# Set up the server
resource "hcloud_server" "g01" {
  name         = module.server.serverName_g01
  image        = module.server.serverImage
  server_type  = module.server.serverType
  location     = module.server.serverLocation

  ssh_keys     = [for key in hcloud_ssh_key.sshKeys : key.id]
  firewall_ids = [module.firewall.firewallID]

  user_data = file("cloud-init.yaml")
}
#endregion