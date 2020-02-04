# OCI File Storage Service Module Example

## Introduction

This example shows how to provision 1 X FSS instances across one region/tenancy.

The following resources are created in this example:

* 1 x File Storage(fs) instance that contains:
* 1 Mount Target(mt):
      * 1 X Export Set containing:
        * 1 x Export that maps the mt with the fs via export -> export_set

## Topology Diagram
This example is intended to the following OCI topology:

![\label{mylabel}](/docs/SingleRegionFSS.jpg)

## Using this example
* Prepare one variable file named `terraform.tfvars` with the required IAM information. The contents of `terraform.tfvars` should look something like the following (or copy and re-use the contents of `terraform.tfvars.template`:

```
### TENANCY DETAILS

# Get this from the bottom of the OCI screen (after logging in, after Tenancy ID: heading)
tenancy_id="<tenancy OCID"
# Get this from OCI > Identity > Users (for your user account)
user_id="<user OCID>"

# the fingerprint can be gathered from your user account (OCI > Identity > Users > click your username > API Keys fingerprint (select it, copy it and paste it below))
fingerprint="<PEM key fingerprint>"
# this is the full path on your local system to the private key used for the API key pair
private_key_path="<path to the private key that matches the fingerprint above>"

# region (us-phoenix-1, ca-toronto-1, etc)
region="<your region>"
```

* Set up the provider:

`providers.tf`:

```
provider "oci" {
  tenancy_ocid     = "${var.tenancy_id}"
  user_ocid        = "${var.user_id}"
  fingerprint      = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region           = "${var.region}"
}
```
`main.tf`:

```
module "oci_file_storage_service" {

  source = "../../"

  providers = {
    oci.custom_provider = "oci"
  }

  file_storage_config = var.file_storage_config
}
```

Edit your `fss.auto.tfvars` file:

```
file_storage_config = {
  default_compartment_id = "<default_compartment_ocid>"
  default_defined_tags   = "<default_defined_tags>"
  default_freeform_tags  = "<default_freeform_tags>"
  default_ad             = "<default_ad>"
  file_systems = {
    fs_1 = {
      ad             = 1
      compartment_id = "<specific_compartment_ocid>"
      defined_tags   = "<specific_defined_tags>"
      freeform_tags  = "<specific_freeform_tags>"
    }
  }
  mount_targets = {
    fs1_mt1 = {
      ad             = "<ad_number_integer>"
      subnet_id      = "<subnet_id>"
      hostname_label = "fs1-mt1"
      ip_address     = "<ip_address>"
      compartment_id = "<specific_compartment_ocid>"
      defined_tags   = "<specific_defined_tags>"
      freeform_tags  = "<specific_freeform_tags>"
      export_set = {
        max_fs_stat_bytes = "<max capacity in bytes>"
        max_fs_stat_files = "<max files capacity>"
      }
      file_systems = {
        "<file system name>" = {
          path          = "<mount path>"
          export_option = "standard_export_options"
        }
      }
    }
  }
  export_options = {
    standard_export_options = {
      source                         = "0.0.0.0/0"
      access                         = "READ_WRITE"
      anonymous_gid                  = null
      anonymous_uid                  = null
      identity_squash                = "NONE"
      require_privileged_source_port = "false"
    }
  }
}
```

Then apply the example using the following commands:

```
$ terraform init
$ terraform plan
$ terraform apply
```
