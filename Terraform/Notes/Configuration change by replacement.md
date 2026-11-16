# Config changes by replacement

## Configuration changes via cloud-init.

Usually any given service will have a configuration file (in e.g. `/etc`).
Commonly formatted as key-value store.

To avoid having to replace every file wholesale is to access specific properties.

## Trigger
Packages listen for conditions and execute commands.

### SED
Editor for `find and replace` operations:
```bash
sed -ie '/^prop1/s/^.*$/prop1 newValue/' /etc/service-xy/config
systemctl reload service xy
```

### Problems
Changes after our edit.
Revert changes before uninstalling.

## Solution
`conf.d` directory allows for multiple files to be processed for configurations.
Higher numbers have higher priority.