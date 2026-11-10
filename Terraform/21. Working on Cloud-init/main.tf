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

#region Firewalls
module "firewall" {
  source = "../Modules/Firewall"
}

resource "hcloud_firewall" "nginx" {
  name = "nginx"

  dynamic "rule" {
    for_each = {
      for name in ["ssh", "icmp", "http"] : name => module.firewall.firewall_rules[name]
    }
    content {
      description = rule.value.description
      direction   = rule.value.direction
      protocol    = rule.value.protocol
      port        = rule.value.protocol == "icmp" ? null : rule.value.port
      source_ips  = rule.value.source_ips
    }
  }
}
#endregion

#region Templates
resource "local_file" "index" {
  content = templatefile("templates/index.html", {
    creationDate = timestamp()
    serverName   = module.server.serverName_g01
    ipv4Address  = hcloud_primary_ip.ipv4.ip_address
    ipv6Address  = hcloud_primary_ip.ipv6.ip_address
    ipv6Subnet   = hcloud_primary_ip.ipv6.ip_network
  })
  filename = "gen/index.html"
}

resource "local_file" "cloud-init" {
  content = templatefile("templates/cloud-init.yaml", {
    html = local_file.index.content
  })
  filename = "gen/cloud-init.yaml"
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
  firewall_ids = [hcloud_firewall.nginx.id]

  public_net {
    ipv4 = hcloud_primary_ip.ipv4.id
    ipv6 = hcloud_primary_ip.ipv6.id
  }

  user_data = local_file.cloud-init.content
}
#endregion