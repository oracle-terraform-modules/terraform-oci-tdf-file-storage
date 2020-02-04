# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {
  # file storage config
  file_storage_config = {
    default_compartment_id = var.compartment_id
    default_defined_tags   = {}
    default_freeform_tags  = {}
    default_ad             = 1
    file_systems = {
      fs_1 = {
        ad             = 1
        compartment_id = null
        defined_tags   = null
        freeform_tags  = null
      }
      fs_2 = {
        ad             = 1
        compartment_id = null
        defined_tags   = null
        freeform_tags  = null
      }
    }
    mount_targets = {
      mt1 = {
        ad             = 1
        subnet_id      = oci_core_subnet.test_subnet.id
        hostname_label = "mt1"
        ip_address     = null
        compartment_id = null
        defined_tags   = null
        freeform_tags  = null
        export_set = {
          max_fs_stat_bytes = 23843202333
          max_fs_stat_files = 223442
        }
        file_systems = {
          fs_1 = {
            path          = "/fs1mt1es1e1"
            export_option = "standard_export_options"
          }
          fs_2 = {
            path          = "/fs2mt1es1e1"
            export_option = "standard_export_options"
          }
        }
      }
      mt2 = {
        ad             = 1
        subnet_id      = oci_core_subnet.test_subnet.id
        hostname_label = "mt2"
        ip_address     = null
        compartment_id = null
        defined_tags   = null
        freeform_tags  = null
        export_set = {
          max_fs_stat_bytes = 23843202333
          max_fs_stat_files = 223442
        }
        file_systems = {
          fs_1 = {
            path          = "/fs1mt2es1e1"
            export_option = "standard_export_options"
          }
          fs_2 = {
            path          = "/fs2mt2es1e1"
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
}

module "oci_file_storage_service" {

  source = "../../"

  providers = {
    oci.custom_provider = "oci"
  }

  file_storage_config = local.file_storage_config
}

resource "oci_core_vcn" "test_vcn" {
  provider       = "oci"
  dns_label      = "temp"
  cidr_block     = "192.168.0.0/16"
  compartment_id = var.compartment_id
  display_name   = "temp"
}

resource "oci_core_subnet" "test_subnet" {
  provider       = "oci"
  cidr_block     = "192.168.10.0/24"
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.test_vcn.id
  display_name   = "temp_subnet"
  dns_label      = "tempsubnet"
}

