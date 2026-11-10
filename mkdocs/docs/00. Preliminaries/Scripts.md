# Scripts

## Init script (_init.sh_)

The script _inits.sh_ was written to facilitate easy module creation.
It creates an exercise directory, copies the top level .env file and template Terraform code, and runs `terraform init` in the newly created directory: 
```
.
├── README.md
├── mkdocs
└── Terraform
    ├── init.sh
    └── ...
```
## Apply script (_apply.sh_)

A script to prepare the shell and call `terraform apply` is provided in the _Terraform_ directory:
```
.
├── README.md
├── mkdocs
└── Terraform
    ├── apply.sh
    └── ...
```

It can be called with any exercise number as a command line argument.
The script will source the `.env` file in the directory of the provided exercise number and call both `terraform init` and `terraform apply` from inside the directory.

The script was written to make the exercise results easily reproducible from the course work home directory (_Terraform_). 