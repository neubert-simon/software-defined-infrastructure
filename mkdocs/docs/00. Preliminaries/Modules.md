# Modules

This section will detail all common modules not specifically created for any one task.
Different modules have been created in the `Modules` directory, which instantiate resources, generate files and provide
_outputs_ that are used throughout the
project.
To learn more, visit:

- [HashiCorp - Modules](https://developer.hashicorp.com/terraform/language/modules)
- [HashiCorp - Outputs](https://developer.hashicorp.com/terraform/language/values/outputs)

## Conf

The file `config.tf` contains commonly used values, including SSH-keys of authorized users for the
servers created when running the exercise solutions.
Update `config.tf.template` with your desired values and rename it to `config.tf` **before running `terraform apply`**.

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
> If you wish to chose a location for the scripts that isn't known to your machine via `$PATH`, take care to invoke the
> scripts like you
> would any regular shell script (`./`).

To learn more, visit;

- [The Linux Documentation Project - PATH](https://www.linfo.org/path_env_var.html)
- [The Linux Foundation - /bin](https://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s04.html)

## Firewall

The file `rules.tf` contains common firewall rules, which are used for dynamic rule creation in `main.tf`:

```terraform
resource "hcloud_firewall" "firewall" {
  name = "dynamic_firewall"

  dynamic "rule" {
    for_each = {
      for name in var.rules : name => local.firewall_rules[name]
    }
    content {
      description = rule.value.description
      direction   = rule.value.direction
      protocol    = rule.value.protocol
      port        = rule.value.port == "icmp" ? null : rule.value.port
      source_ips  = rule.value.source_ips
    }
  }
}

```

To learn more, visit:

- [Terraform Registry - hcloud_firewall](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/firewall)
- [HashiCorp - Dynamic Blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks)

The rule names are passed in as variables (declared in `variables.tf`) when the module is instantiated:

```terraform
variable "rules" {
  description = "List of names of the firewall rules to apply"
  type = list(string)
}

```

One example of a common firewall rule (_SSH-Traffic via Port 22_) inside `rules.tf`:

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

To learn more about locals, visit:

- [HashiCorp - Locals](https://developer.hashicorp.com/terraform/language/values/locals)

These rules are accessible via the modules respective `output` directive:

```terraform
output "firewall_rules" {
  description = "Reusable firewall rule definitions"
  value       = local.firewall_rules
}
```

The firewall resource that gets created upon module instantiation is accessible via its ID through the respective
`output` directive too:

```terraform
output "firewallID" {
  description = "Firewall ID"
  type        = string
  value       = hcloud_firewall.firewall.id
}

```

## Hetzner

Most exercises utilize cloud init to configure SSH (see [Templates -
_cloud-init_ for SSH](./Templates.md#_cloud-init_-for-ssh)).
Since Hetzner doesn't know that root login via password will be disabled this way, the service generates an E-Mail with
the root password if no SSH keys are provided.

This module creates an SSH key resource that can be added to the server to prevent the E-Mail, even though it they will
not be used directly to log in as `root` in most circumstances.

```terraform
resource "hcloud_ssh_key" "sshKeys" {
  for_each   = module.config.authorizedKeys
  name       = each.key
  public_key = each.value
}
```

Access the key IDs via the `output` directive below:

```terraform
output "authorizedKeys" {
  description = "List of authorized key IDs"
  value       = [for key in hcloud_ssh_key.sshKeys : key.id]
}
```

## Server

The file `output.tf` contains common server attributes, which have been added to the server resource present
in `Templates/main.tf.template`:

```terraform
resource "hcloud_server" "g01" {
  name        = module.server.serverName_g01
  image       = module.server.serverImage
  server_type = module.server.serverType
  location    = module.server.serverLocation
}
```

Below is an example of such an `output` directive.
If the cheapest server type is unavailable, you can change the server type in this module to apply the change to all
solutions simultaneously:

```terraform
output "serverType" {
  description = "The cheapest server Type (cx23)"
  value       = "cx23" // Use cpx02 if cx23 is unavailable
}

```

To learn more, visit:

- [Terraform Registry - hcloud_server](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/server.html)

## SSH

This module was added as part of the solution
for [Ex. 25 - A module for ssh host key handling](../25.%20A%20module%20for%20ssh%20host%20key%20handling/1.%20Solution.md).
It has been in use for most exercises following no. 25, therefore it will be explained here briefly.

The `SSH` module creates a _cloud-init_ configuration for the default SSH configuration with the following setup:

- Disable root login
- Disable password authentication
- Set up an authorized user with sudo privileges (default: `devops`)
- Set up authorized keys for the aforementioned user
- Create and pass an SSH key-pair the server will use (see [SshKnownHosts](#sshknownhosts))

## SshKnownHosts

This module was added as part of the solution
for [Ex. 25 - A module for ssh host key handling](../25.%20A%20module%20for%20ssh%20host%20key%20handling/1.%20Solution.md).
It has been in use for most exercises following no. 25, therefore it will be explained here briefly.

The `SshKnownHosts` module creates wrappers for the SSH and SCP commands.

It creates three local files to that end:

1. `known_hosts`<br>
   A _known_hosts_ file will be created in the `gen` directory of the calling module.
   This file contains the server's IP and public key.

2. `ssh` wrapper<br>
   A wrapper script for _ssh_ will be created in your `bin` directory.
   It uses the `known_hosts` file to avoid a host key verification failure.

3. `scp`wrapper<br>
   A wrapper script for _scp_ will be created in your `bin` directory.
   It uses the `known_hosts` file to avoid a host key verification failure.