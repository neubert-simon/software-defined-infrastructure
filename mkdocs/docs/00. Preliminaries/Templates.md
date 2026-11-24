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

> If you elect not to use the [init.sh](Scripts.md#init-script-_initsh_) script when creating a new module for an
> exercise, you need to manually copy the template files into the exercise directory and remove the `.template` suffix.

## .env.template

This template contains the environment variables which are used throughout many solutions. **Copy the template into the
desired exercise directory and change the contents to contain your secrets.
Rename the file to `.env` and source it to reproduce the documented results**:

```dotenv
export TF_VAR_hcloud_token=add_your_hetzner_api_token_here
export TF_VAR_dns_secret=add_your_dns_secret_here
```

To learn more, visit:

- [Dotenv](https://dotenvx.com/docs/env-file/)
- [The Linux Documentation Project - Sourcing a file](https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x237.html)

## main.tf

The file `main.tf` contains the default server configuration, which uses the server attributes specified in
`Modules/Conf`, the firewall created via `Modules/Firewall`, the SSH keys created via `Modules/Hetzner`, and the
_cloud-init_ local
file created via `Modules/SSH`:

```terraform
# Set up the default server
resource "hcloud_server" "g01" {
  name        = module.server.serverName_g01
  image       = module.server.serverImage
  server_type = module.server.serverType
  location    = module.server.serverLocation

  firewall_ids = [module.firewall.firewallID]
  ssh_keys = module.hetzner.authorizedKeys

  user_data = local_file.user_data.content

  depends_on = [local_file.user_data]
}
```

See [Modules](Modules.md) to learn more about the common modules.

## setup.tf

The file `setup.tf` sets up the common configuration shared by most exercises.

### Providers

The `hcloud` and `local` providers, since Hetzner is used in every exercise, and most exercises use
cloud-init to configure SSH among other things.

```terraform

# Register the provider
terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
    local = {
      source = "hashicorp/local"
    }
  }
  required_version = ">= 1.5"
}

```

### Hetzner

The API token is set up as well:

```terraform
# Configure the Hetzner Cloud API token

variable "hcloud_token" {
  description = "Hetzner API token"
  type        = string
  nullable    = false
  sensitive   = true
}

provider "hcloud" { token = var.hcloud_token }
```

### Common Modules

The common modules are instantiated:

```terraform
# Load the common configuration

module "config" { source = "../Modules/Conf" }

module "server" { source = "../Modules/Server" }

module "hetzner" {
  source       = "../Modules/Hetzner"
  hcloud_token = var.hcloud_token
}
```

### Firewall

The `Firewall` module is set up.
There is a placeholder for the firewall rule names, which has to be replaced before the configuration will work:

```terraform
# Firewall
module "firewall" {
  source = "../Modules/Firewall"
  rules = [ADD_FIREWALL_RULE_HERE]
}
```

### SSH

The default SSH configuration is loaded. This generates the _cloud-init_ file provided by the `SSH` module, as well as
the SSH wrapper scripts created via the `SshKnownHosts` module:

```terraform
#SSH config
module "ssh" {
  source = "../Modules/SSH"
  moduleDir = abspath(path.module)
}

#SSH wrapper
module "ssh_wrapper" {
  source           = "../Modules/SshKnownHosts"
  moduleDir = abspath(path.module)
  bin              = module.config.bin
  user_private_key = module.config.pk
  host_public_key  = module.ssh.host_public_key
  server           = hcloud_server.g01.id
  user             = module.config.loginUserName

  depends_on = [hcloud_server.g01]
}
```