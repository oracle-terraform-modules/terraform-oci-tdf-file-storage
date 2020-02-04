# file storage details

file_storage_config = {
  default_compartment_id = "<default_compartment_ocid>"
  default_defined_tags   = "<default_defined_tags>"
  default_freeform_tags  = "<default_freeform_tags>"
  default_id             = "<default_ad>"
  file_systems = {
    fs_2 = {
      ad             = 1
      compartment_id = "<specific_compartment_ocid>"
      defined_tags   = "<specific_defined_tags>"
      freeform_tags  = "<specific_freeform_tags>"
    }
    fs_2 = {
      ad             = 2

      compartment_id = "<specific_compartment_ocid>"
      defined_tags   = "<specific_defined_tags>"
      freeform_tags  = "<specific_freeform_tags>"
    }
  }
  mount_targets = {
    mt1 = {
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
        "<file system name>" = {
          path          = "<mount path>"
          export_option = "standard_export_options"
        }
      }
    }
    mt2 = {
      ad             = "<ad_number_integer>"
      subnet_id      = "<subnet_id>"
      hostname_label = "fs1-mt2"
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