# OCI File Storage Service Module Example

## Introduction

This example shows how to provision 2 FSS instances across 2 regions/tenancies

The following resources are created in this example:

* 2 x File System(fs) instances in 2 different regions/tenancies
* 2 Mount Targets(mt), in 2 different regions/tenancies, one per each fs above:
      * 1 X Export Set per mt containing:
        * 1 x Export - which links the fs with the mt via export_set -> export

## Topology Diagram
This example is intended to the following OCI topology:

![\label{mylabel}](/docs/MultipleRegionsFSSs.jpg)

## Using this example
* Prepare one variable file named `terraform.tfvars` with the required IAM information. The contents of `terraform.tfvars` should look something like the following (or copy and re-use the contents of `terraform.tfvars.template`:

```
### PRIMARY TENANCY DETAILS

# Get this from the bottom of the OCI screen (after logging in, after Tenancy ID: heading)
primary_tenancy_id="<tenancy OCID"
# Get this from OCI > Identity > Users (for your user account)
primary_user_id="<user OCID>"

# the fingerprint can be gathered from your user account (OCI > Identity > Users > click your username > API Keys fingerprint (select it, copy it and paste it below))
primary_fingerprint="<PEM key fingerprint>"
# this is the full path on your local system to the private key used for the API key pair
primary_private_key_path="<path to the private key that matches the fingerprint above>"

# region (us-phoenix-1, ca-toronto-1, etc)
primary_region="<your region>"

### DR TENANCY DETAILS

# Get this from the bottom of the OCI screen (after logging in, after Tenancy ID: heading)
dr_tenancy_id="<tenancy OCID"
# Get this from OCI > Identity > Users (for your user account)
dr_user_id="<user OCID>"

# the fingerprint can be gathered from your user account (OCI > Identity > Users > click your username > API Keys fingerprint (select it, copy it and paste it below))
dr_fingerprint="<PEM key fingerprint>"
# this is the full path on your local system to the private key used for the API key pair
dr_private_key_path="<path to the private key that matches the fingerprint above>"

# region (us-phoenix-1, ca-toronto-1, etc)
dr_region="<your region>"
```

* Set up the primary and dr providers:

`providers.tf`:

```
provider "oci" {
  alias            = "primary"
  tenancy_ocid     = "${var.primary_tenancy_id}"
  user_ocid        = "${var.primary_user_id}"
  fingerprint      = "${var.primary_fingerprint}"
  private_key_path = "${var.primary_private_key_path}"
  region           = "${var.primary_region}"
}

provider "oci" {
  alias            = "dr"
  tenancy_ocid     = "${var.dr_tenancy_id}"
  user_ocid        = "${var.dr_user_id}"
  fingerprint      = "${var.dr_fingerprint}"
  private_key_path = "${var.dr_private_key_path}"
  region           = "${var.dr_region}"
}
```


`main.tf`:

```
module "primary_oci_file_storage_service" {

  source = "../../"

  providers = {
    oci.custom_provider = "oci.primary"
  }

  # File Storage Variable

  file_storage_config = {
    default_compartment_id = var.default_values.default_compartment_id
    default_defined_tags   = var.default_values.default_defined_tags
    default_freeform_tags  = var.default_values.default_freeform_tags
    default_ad             = var.file_storage_config_primary.default_ad
    file_systems           = var.file_storage_config_primary.file_systems
    mount_targets          = var.file_storage_config_primary.mount_targets
    export_options         = var.default_values.export_options
  }

}

module "dr_oci_file_storage_service" {

  source = "../../"

  providers = {
    oci.custom_provider = "oci.dr"
  }

  # File Storage Variable

  file_storage_config = {
    default_compartment_id = var.default_values.default_compartment_id
    default_defined_tags   = var.default_values.default_defined_tags
    default_freeform_tags  = var.default_values.default_freeform_tags
    default_ad             = var.file_storage_config_dr.default_ad
    file_systems           = var.file_storage_config_dr.file_systems
    mount_targets          = var.file_storage_config_dr.mount_targets
    export_options         = var.default_values.export_options
  }
}
```

Edit your `fsss.auto.tfvars` file:

```
# default values across the 2 regions/tenancies

default_values = {
  default_compartment_id = "<default_compartment_ocid>"
  default_defined_tags   = "<default_defined_tags>"
  default_freeform_tags  = "<default_freeform_tags>"
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

# fss primary details
file_storage_config_primary = {
  default_ad = 1
  file_systems = {
    primary_fs_1 = {
      ad             = "<specific_ad_number>"
      compartment_id = "<specific_compartment_ocid>"
      defined_tags   = "<specific_defined_tags>"
      freeform_tags  = "<specific_freeform_tags>"
    }
  }
  mount_targets = {
    primary_fs1_mt1 = {
      ad             = null
      subnet_id      = "<subnet_id>"
      hostname_label = "primary-fs1-mt1"
      ip_address     = "<ip_address>"
      compartment_id = "<specific_compartment_ocid>"
      defined_tags   = "<specific_defined_tags>"
      freeform_tags  = "<specific_freeform_tags>"
      export_set = {
        max_fs_stat_bytes = "<max capacity in bytes>"
        max_fs_stat_files = "<max files capacity>"
      }
      file_systems = {
        primary_fs_1 = {
          path          = "<mount path>"
          export_option = "standard_export_options"
        }
      }
    }
  }
}

# fss dr details

file_storage_config_dr = {
  default_ad = 2
  file_systems = {
    dr_fs_1 = {
      ad             = "<specific_ad_number>"
      compartment_id = "<specific_compartment_ocid>"
      defined_tags   = "<specific_defined_tags>"
      freeform_tags  = "<specific_freeform_tags>"
    }
  }
  mount_targets = {
    dr_fs1_mt1 = {
      ad             = null
      subnet_id      = "<subnet_id>"
      hostname_label = "dr-fs1-mt1"
      ip_address     = "<ip_address>"
      compartment_id = "<specific_compartment_ocid>"
      defined_tags   = "<specific_defined_tags>"
      freeform_tags  = "<specific_freeform_tags>"
      export_set = {
        max_fs_stat_bytes = "<max capacity in bytes>"
        max_fs_stat_files = "<max files capacity>"
      }
      file_systems = {
        dr_fs_1 = {
          path          = "<mount path>"
          export_option = "standard_export_options"
        }
      }
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
