#region Network
resource "hcloud_primary_ip" "ipv4" {
  name        = "primary-ipv4"
  location    = module.server.serverLocation
  type        = "ipv4"
  auto_delete = true
}

resource "hcloud_primary_ip" "ipv6" {
  name        = "primary-ipv6"
  location    = module.server.serverLocation
  type        = "ipv6"
  auto_delete = true
}
#endregion

#region Templates
resource "local_file" "index" {
  content = templatefile("${path.module}/templates/index.html", {
    creationDate = timestamp()
    serverName   = module.server.serverName_g01
    ipv4Address  = hcloud_primary_ip.ipv4.ip_address
    ipv6Address  = hcloud_primary_ip.ipv6.ip_address
    ipv6Subnet   = hcloud_primary_ip.ipv6.ip_network
  })
  filename = "${path.module}/gen/index.html"
}

resource "local_file" "cloud-init" {
  content = templatefile("${path.module}/templates/cloud-init.yaml", {
    html = local_file.index.content
  })
  filename = "${path.module}/gen/cloud-init.yaml"
}
#endregion

#region Server
module "server" {
  source = "../Modules/Server"
}

resource "hcloud_server" "g01" {
  name         = module.server.serverName_g01
  image        = module.server.serverImage
  server_type  = module.server.serverType
  location     = module.server.serverLocation
  ssh_keys     = [for key in hcloud_ssh_key.sshKeys : key.id]
  firewall_ids = [module.firewall.firewallID]

  public_net {
    ipv4 = hcloud_primary_ip.ipv4.id
    ipv6 = hcloud_primary_ip.ipv6.id
  }

  user_data = local_file.cloud-init.content
}
#endregion