# Set up the default server
resource "hcloud_server" "g01" {
  name        = module.server.serverName_g01
  image       = module.server.serverImage
  server_type = module.server.serverType
  location    = module.server.serverLocation

  firewall_ids = [module.firewall.firewallID]
  ssh_keys     = [for key in hcloud_ssh_key.sshKeys : key.id]

}

module "metaData" {
  source     = "../Modules/HostMetaData"
  server     = hcloud_server.g01.id
  depends_on = [hcloud_server.g01]
}
