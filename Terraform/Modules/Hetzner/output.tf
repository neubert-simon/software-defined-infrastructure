output "authorizedKeys" {
  description = "List of authorized key IDs"
  value = [for key in hcloud_ssh_key.sshKeys : key.id]
}