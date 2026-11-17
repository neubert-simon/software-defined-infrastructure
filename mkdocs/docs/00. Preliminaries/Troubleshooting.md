# Troubleshooting

This section chronicles common issues encountered while working on the submissions that are too general to explain in any given solution.

## Server Type
Every exercise solution that requires server creation uses the cheapest Hetzner server type `cx23`.
These servers are not selectable via the GUI, but can still be created via the API.
It can happen that all servers of this type are unavailable, in which case `terrraform apply` will produce the error:

> resource unavailable

If this were to happen, you may elect to switch to a more expensive server type like `cx02` to continue examining the provided solutions.

## Operating System Differences
Solutions were produced on `OS X`. Operating System differences may lead to solutions not working right out of the box without adjustments.

### File Paths
If file paths seem to be incorrect, check if your operating system expects different characters delineating inodes or if escape sequences differ.

### Dependency Lock Files
Lock files have been committed to version control, since they contain the provider versions used when the exercise solutions were submitted.
This was done to document with which version solutions were functional, in case a later release breaks the provided source code.
If you are using a different operating system or are installing providers from a custom source, the lock files may cause problems. 

The lock files have been populated with checksums for multiple major operating system versions. If you still encounter problems check if your operating system was omitted:
```bash
terraform providers lock \
  -platform=windows_amd64 \
  -platform=windows_arm64
  -platform=linux_amd64 \
  -platform=linux_arm64 \
  -platform=darwin_amd64 \
  -platform=darwin_arm64
```

If you wish to run the submitted code with the most recent available provider versions, run `terraform init -upgrade`.

To read more, visit:

- [HashiCorp - Dependency Lock Files](https://developer.hashicorp.com/terraform/language/files/dependency-lock)
- [HashiCorp - terraform providers lock command](https://developer.hashicorp.com/terraform/cli/commands/providers/lock#specifying-target-platforms)

## Permissions
If shell scripts aren't executable after cloning the repository, check and set the execution permissions for your user.
When writing files to directories (like e.g. `/usr/bin`), ensure these directories can be written to.