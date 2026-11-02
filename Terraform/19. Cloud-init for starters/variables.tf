variable "hcloud_token" {
  description = "Hetzner API token"
  type = string
  nullable = false
  sensitive = true
}

variable "serverImage" {
  description = "Server image"
  type = string
  nullable = true
  default = "debian-13"
}

variable "serverType" {
  description = "Server type"
  type = string
  nullable = true
  default = "cx23"
}