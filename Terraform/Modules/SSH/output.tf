output "ssh_config" {
  description = "SSH config file content"
  value = local_file.ssh_config.content
}

output "host_public_key" {
  value = tls_private_key.host.public_key_openssh
}