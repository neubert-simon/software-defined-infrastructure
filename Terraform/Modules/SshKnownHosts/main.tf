data "hcloud_server" "server" {
  id = var.server
}

resource "local_file" "known_hosts" {
  content = join(" ",
    [data.hcloud_server.server.ipv4_address, var.host_public_key]
  )
  filename        = "gen/known_hosts"
  file_permission = "644"
}

resource "local_file" "ssh_script" {
  content = templatefile("${path.module}/templates/ssh.sh", {
    ip    = data.hcloud_server.server.ipv4_address
    user  = var.user
    pk    = var.user_private_key
    exDir = var.moduleDir
  })
  filename        = "${var.bin}/ssh${data.hcloud_server.server.name}"
  file_permission = "755"
  depends_on      = [local_file.known_hosts]
}

resource "local_file" "scp_script" {
  content = templatefile("${path.module}/templates/scp.sh", {
    ip    = data.hcloud_server.server.ipv4_address
    pk    = var.user_private_key
    exDir = var.moduleDir
  })
  filename        = "${var.bin}/scp${data.hcloud_server.server.name}"
  file_permission = "755"
  depends_on      = [local_file.known_hosts]
}
