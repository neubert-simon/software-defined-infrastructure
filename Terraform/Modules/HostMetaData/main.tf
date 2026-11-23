data "hcloud_server" "server" {
  id = var.server
}

resource "local_file" "hostdata" {
  content    = templatefile("${path.module}/templates/hostdata.json", {
    name     = data.hcloud_server.server.name
    ip4      = data.hcloud_server.server.ipv4_address
    ip6      = data.hcloud_server.server.ipv6_address
    location = data.hcloud_server.server.location
  })
  filename        = "gen/${data.hcloud_server.server.name}_metadata.json"
  file_permission = "0644"
  depends_on = [data.hcloud_server.server]
}