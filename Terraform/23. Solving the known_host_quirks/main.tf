#region Server
module "server" { source = "../Modules/Server" }

resource "tls_private_key" "host" { algorithm = "ED25519" }

resource "local_file" "user_data" {
  filename = "${path.module}/gen/user-data.yaml"
  content = templatefile("${path.module}/templates/user-data.yaml", {
    host_ed25519_private = tls_private_key.host.private_key_openssh
    host_ed25519_public  = tls_private_key.host.public_key_openssh
    devopsUsername       = module.config.loginUserName
    ssh_authorized_keys  = module.config.authorizedKeys
  })
  depends_on = [tls_private_key.host]
}

resource "hcloud_server" "g01" {
  name        = module.server.serverName_g01
  image       = module.server.serverImage
  server_type = module.server.serverType
  location    = module.server.serverLocation

  ssh_keys     = [for key in hcloud_ssh_key.sshKeys : key.id]
  firewall_ids = [hcloud_firewall.SSH.id]
  user_data    = local_file.user_data.content

  depends_on = [local_file.user_data]
}
#endregion

#region Local files for SSH known host authentication
resource "local_file" "known_hosts" {
  content = join(" ",
    [hcloud_server.g01.ipv4_address, tls_private_key.host.public_key_openssh]
  )
  filename        = "${path.module}/gen/known_hosts"
  file_permission = "644"
  depends_on      = [hcloud_server.g01]
}

resource "local_file" "ssh_script" {
  content = templatefile("${path.module}/templates/ssh.sh", {
    ip     = hcloud_server.g01.ipv4_address
    pk     = module.config.pk
    genDir = "${abspath(path.module)}/gen"
  })
  filename        = "${module.config.bin}/ssh${hcloud_server.g01.name}"
  file_permission = "755"
  depends_on      = [local_file.known_hosts]
}

resource "local_file" "scp_script" {
  content = templatefile("${path.module}/templates/scp.sh", {
    ip     = hcloud_server.g01.ipv4_address
    pk     = module.config.pk
    genDir = "${abspath(path.module)}/gen"
  })
  filename        = "${module.config.bin}/scp${hcloud_server.g01.name}"
  file_permission = "755"
  depends_on      = [local_file.known_hosts]
}
#endregion
