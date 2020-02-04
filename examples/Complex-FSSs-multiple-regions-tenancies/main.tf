# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

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

