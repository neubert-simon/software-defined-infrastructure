variable "server" {
  description = "Server id"
  type        = string
}

variable "user" {
  description = "User to log in as on the server"
  type        = string
}

variable "user_private_key" {
  description = "Private key file to authenticate via ssh with"
  type        = string
  sensitive   = true
  nullable    = true
}

variable "host_public_key" {
  description = "Public key used by the host system"
  type        = string
}

variable "moduleDir" {
  description = "Absolute path to the module directory"
  type        = string
}

variable "bin" {
  description = "Filepath to bin directory on $PATH"
  type        = string
}
