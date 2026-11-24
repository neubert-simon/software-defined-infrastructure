# Set up the default server
resource "hcloud_server" "g01" {
  name         = module.server.serverName_g01
  image        = module.server.serverImage
  server_type  = module.server.serverType
  location     = module.server.serverLocation

  firewall_ids = [module.firewall.firewallID]
  ssh_keys     = module.hetzner.authorizedKeys

  user_data    = module.ssh.ssh_config
  depends_on   = [module.server, module.hetzner, module.ssh, module.firewall]
}

#SSH wrapper
module "ssh_wrapper" {
  source           = "../Modules/SshKnownHosts"
  moduleDir        = abspath(path.module)
  bin              = module.config.bin

  user             = module.config.loginUserName
  user_private_key = module.config.pk

  host_public_key  = module.ssh.host_public_key
  server           = hcloud_server.g01.id

  depends_on       = [hcloud_server.g01]
}
