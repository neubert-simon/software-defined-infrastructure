output "authorizedKeys" {
  description = "List of authorized users' public ssh keys"
  type = map(string)

  value = {
    neubert = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII12SWradHBuyiHJDTJmulP9LMsEeyXajvaCnZxgtKh0 sn067@hdm-stuttgart.de"
    goik    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKY24AeEibQGSMPtstaN4REByLCM3kzjM//apEZ9WyUB goik@hdm-stuttgart.de"
  }
}