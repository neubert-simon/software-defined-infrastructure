module "config" { source = "../Conf" }

resource "tls_private_key" "host" { algorithm = "ED25519" }

resource "local_file" "ssh_config" {
  filename = "${var.moduleDir}/gen/ssh.yaml"
  content = templatefile("${path.module}/templates/ssh.yaml", {
    host_ed25519_private = tls_private_key.host.private_key_openssh
    host_ed25519_public  = tls_private_key.host.public_key_openssh
    devopsUsername       = module.config.loginUserName
    ssh_authorized_keys  = module.config.authorizedKeys
  })
  depends_on = [tls_private_key.host]
}