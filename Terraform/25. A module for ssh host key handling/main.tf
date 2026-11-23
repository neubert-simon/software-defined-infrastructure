#region Server
module "server" { source = "../Modules/Server" }

resource "tls_private_key" "host" { algorithm = "ED25519" }

resource "local_file" "user_data" {
  filename = "${path.module}/gen/user_data.yaml"
  content = templatefile("${path.module}/templates/user-data.yaml", {
    host_ed25519_private = tls_private_key.host.private_key_openssh
    host_ed25519_public  = tls_private_key.host.public_key_openssh
    devopsUsername       = module.config.loginUserName
    ssh_authorized_keys  = module.config.authorizedKeys
  })
  depends_on = [tls_private_key.host]
}

# Set up the default server
resource "hcloud_server" "g01" {
  name        = module.server.serverName_g01
  image       = module.server.serverImage
  server_type = module.server.serverType
  location    = module.server.serverLocation

  firewall_ids = [hcloud_firewall.SSH.id]
  ssh_keys     = [for key in hcloud_ssh_key.sshKeys : key.id]

  user_data = local_file.user_data.content
  depends_on = [local_file.user_data]
}
#endregion

module "ssh_wrapper" {
  source           = "../Modules/SshKnownHosts"
  moduleDir        = abspath(path.module)
  bin              = module.config.bin
  user_private_key = module.config.pk
  host_public_key  = tls_private_key.host.public_key_openssh
  server           = hcloud_server.g01.id
  user             = module.config.loginUserName

  depends_on = [hcloud_server.g01]
}
