# devops-reference-arch-oke

### Clone the Repo

Now, you'll want a local copy of this repo. You can make that with the commands:

```
    git clone https://github.com/oracle-quickstart/oci-arch-devops.git
    cd oci-arch-devops/devops_oke
    ls
```

### Prerequisites
First off, you'll need to do some pre-deploy setup.  That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

Create a `terraform.tfvars` file, and specify the following variables:

```
# Authentication
tenancy_ocid         = "<tenancy_ocid>"
user_ocid            = "<user_ocid>"
fingerprint          = "<finger_print>"
private_key_path     = "<pem_private_key_path>"

# Region
region = "<oci_region>"

# Availablity Domain 
availablity_domain_name = "<availablity_domain_name>"

````

### Create the Resources
Run the following commands:

    terraform init
    terraform plan
    terraform apply


### Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy the resources:

    terraform destroy




