# Templates

Templates can be found in the `Modules` directory:
```
.
├── README.md
├── mkdocs
└── Terraform
    ├── Modules
    └── ...
```

Different modules have been created based on the provided templates, which are used throughout the project.
To learn more, visit:
- [Terraform - Modules](https://developer.hashicorp.com/terraform/language/modules)

## .env.template

This template contains the environment variables which are used throughout all solutions.
Copy the template into the desired exercise directory and change the contents to contain your secrets.
Rename the file to `.env` and source it to reproduce the documented results.

To learn more, visit:
- [Dotenv](https://dotenvx.com/docs/env-file/)
- [The Linux Documentation Project - Sourcing a file](https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x237.html)

## Conf

The file `Modules/Config/config.tf` contains commonly used values, including SSH-keys of authorized users for the servers created when running the exercise solutions.
If you wish to add an SSH-key, it is sufficient to add it to the `authorizedKeys` output directive, it will be applied to all exercise solutions:

```terraform
output "authorizedKeys" {
  type = map(string)
  value = {
    neubert = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII12SWradHBuyiHJDTJmulP9LMsEeyXajvaCnZxgtKh0 sn067@hdm-stuttgart.de"
    goik    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKY24AeEibQGSMPtstaN4REByLCM3kzjM//apEZ9WyUB goik@hdm-stuttgart.de"
  }
}
```

The file has been committed to version control for easy reproducibility and to allow a complete recreation of the local setup for grading purposes.

## Firewall

The file `Modules/Firewall/firewall.tf` contains common firewall rules, which can be added to the dynamic rule creation present in `Templates/main.tf.template`:

```terraform
resource "hcloud_firewall" "TEMPLATE" {
  name = "TEMPLATE"

  dynamic "rule" {
    for_each = {
      for name in [TEMPLATE_ADD_RULE_NAMES_HERE] : name => module.firewall.firewall_rules[name]
    }
    content {
      description = rule.value.description
      direction   = rule.value.direction
      protocol    = rule.value.protocol
      port        = rule.value.port
      source_ips  = rule.value.source_ips
    }
  }
}
```

One example of a common firewall rule (_SSH-Traffic via 22_):
```terraform
locals {
  firewall_rules = {
    ssh = {
      description = "Allow SSH"
      direction   = "in"
      protocol    = "tcp"
      port        = "2222"
      source_ips  = ["0.0.0.0/0", "::/0"]
    }
    ...
```

These rules are accessible via the modules `output` directive:
```terraform
output "firewall_rules" {
  description = "Reusable firewall rule definitions"
  value       = local.firewall_rules
}
```

## Server

The file `Modules/Server/server.tf` contains common server attributes, which can be added to the server resource present in `Templates/main.tf.template`:

```terraform
resource "hcloud_server" "g01" {
  name         = module.server.serverName_g01
  image        = module.server.serverImage
  server_type  = module.server.serverType
  location     = module.server.serverLocation
  ssh_keys     = [for key in hcloud_ssh_key.sshKeys : key.id]
}
```

These default values are accessible via the modules `output` directive, of which this is one example:
```terraform
output "serverType" {
  description = "The cheapest server Type (cx23)"
  value = "cx23"
}
```