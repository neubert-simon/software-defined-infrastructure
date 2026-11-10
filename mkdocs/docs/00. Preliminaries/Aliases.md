# Aliases

To facilitate more efficient interaction with the CLI tools used when creating cloud infrastructure, some aliases have been created.
These are documented here in case they show up in screenshots of the conducted steps:

### SSHDM

``` bash
alias sshdm="ssh -A -i ~/.ssh/hdm"
```

The public / private key-pair `hdm` was used during the exercise period.
Since multiple key-pairs were available on the host system, an alias was created to make connecting to the Hetzner instances easier.
The flag `-i` passes the specified private key file which will be used to authenticate against the server, while `-A` enables ssh-agent forwarding.

### VCI

```
alias vci='check-jsonschema --schemafile https://raw.githubusercontent.com/canonical/cloud-init/main/cloudinit/config/schemas/schema-cloud-config-v1.json'
```
Short for `validate cloud-init`, this alias was used to shorten the call to a third-party validation utility.
Since the _cloud-init_ package is not available for the system used during course work, the [official JSON schema](https://raw.githubusercontent.com/canonical/cloud-init/main/cloudinit/config/schemas/schema-cloud-config-v1.json) by [Canonical](https://canonical.com) was used to validate _yaml_ configurations via [check-jsonschema](https://formulae.brew.sh/formula/check-jsonschema).
