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