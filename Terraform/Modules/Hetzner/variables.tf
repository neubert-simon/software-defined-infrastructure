# Configure the Hetzner Cloud API token
variable "hcloud_token" {
  description = "Hetzner API token"
  type        = string
  nullable    = false
  sensitive   = true
}