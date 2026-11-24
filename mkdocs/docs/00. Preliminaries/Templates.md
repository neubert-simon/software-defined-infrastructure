# Templates and Modules

Templates can be found in the `Templates` directory:

```
.
├── README.md
├── mkdocs
└── Terraform
    ├── Templates
    └── Modules
    └── ...
```

Different modules have been created in the `Modules` directory, which provide _outputs_ that are used throughout the
project.
To learn more, visit:

- [HashiCorp - Modules](https://developer.hashicorp.com/terraform/language/modules)
- [HashiCorp - Outputs](https://developer.hashicorp.com/terraform/language/values/outputs)

> If you elect not to use the [init.sh](Scripts.md#init-script-_initsh_) script when creating a new module for an
> exercise, you need to manually copy the template files into the exercise directory and remove the `.template` suffix.

## .env.template

This template contains the environment variables which are used throughout many solutions. **Copy the template into the
desired exercise directory and change the contents to contain your secrets.
Rename the file to `.env` and source it to reproduce the documented results.**

To learn more, visit:

- [Dotenv](https://dotenvx.com/docs/env-file/)
- [The Linux Documentation Project - Sourcing a file](https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x237.html)

## Conf

The file `Modules/Config/config.tf` contains commonly used values, including SSH-keys of authorized users for the
servers created when running the exercise solutions.
Update `config.tf.template` with your desired values and rename it to `config.tf`.

If you wish to add an SSH-key, it is sufficient to add it to the `authorizedKeys` output directive, it will be applied
to all exercise solutions using it:

```terraform
output "authorizedKeys" {
  description = "List of authorized users' public ssh keys"
  type = map(string)
  value = { ADD YOUR SSH KEYS HERE }
}
```

To learn how to utilize maps, visit:

- [HashiCorp - Terraform Types and Values](https://developer.hashicorp.com/terraform/language/expressions/types#map)

You may change the username for authorized users on the servers. The default value is `devops`:

```terraform
output "loginUserName" {
  description = "Login user's name with admin privileges"
  type        = string
  value       = "devops"
}
```

To execute generated shell script from any location on your file system, the exercises create them in a user specified
directory.
You may supply a `bin` directory, or any directory on your `$PATH`:

```terraform
output "bin" {
  description = "Local user bin directory"
  type        = string
  value       = ADD YOUR
bin DIRECTORY OR ANY DIRECTORY ON YOUR PATH HERE (ensure terraform can write to the directory)
}
```

**Note**:
> If you wish to chose a location for the scripts that isn't known via `$PATH`, take care to invoke the scripts like you
> would any regular shell script (`./`).

To learn more, visit;

- [The Linux Documentation Project - PATH](https://www.linfo.org/path_env_var.html)
- [The Linux Foundation - /bin](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s04.html)

## Firewall

The file `Modules/Firewall/firewall.tf` contains common firewall rules, which can be added to the dynamic rule creation
present in `Templates/firewall.tf.template`:

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

To learn more, visit:

- [Terraform Registry - hcloud_firewall](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall)
- [HashiCorp - Dynamic Blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks)

One example of a common firewall rule (_SSH-Traffic via 22_) inside `firewall.tf.template`:

```terraform
locals {
  firewall_rules = {
    ssh = {
      description = "Allow SSH"
      direction   = "in"
      protocol    = "tcp"
      port        = "2222"
      source_ips = ["0.0.0.0/0", "::/0"]
    }
    ...
```

To learn more, visit:

- [HashiCorp - Locals](https://developer.hashicorp.com/terraform/language/values/locals)

These rules are accessible via the modules `output` directive:

```terraform
output "firewall_rules" {
  description = "Reusable firewall rule definitions"
  value       = local.firewall_rules
}
```

## Server

The file `Modules/Server/server.tf` contains common server attributes, which can be added to the server resource present
in `Templates/main.tf.template`:

```terraform
resource "hcloud_server" "g01" {
  name        = module.server.serverName_g01
  image       = module.server.serverImage
  server_type = module.server.serverType
  location    = module.server.serverLocation
  ssh_keys    = [for key in hcloud_ssh_key.sshKeys : key.id]
}
```

To learn more, visit:

- [Terraform Registry - hcloud_server](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server.html)

These default values are accessible via the modules `output` directive, of which this is one example:

```terraform
output "serverType" {
  description = "The cheapest server Type (cx23)"
  value       = "cx23"
}
```

## SshKnownHosts

This module creates wrappers for the SSH and SCP commands. It has been in use for most exercises
after [Exercise 25. A module for ssh host key handling](../25.%20A%20module%20for%20ssh%20host%20key%20handling/1.%20Solution.md).

// TODO update