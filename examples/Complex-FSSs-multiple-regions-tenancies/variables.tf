# primary tenancy details
variable "primary_tenancy_id" {}
variable "primary_user_id" {}
variable "primary_fingerprint" {}
variable "primary_private_key_path" {}
variable "primary_region" {}

# dr tenancy details
variable "dr_tenancy_id" {}
variable "dr_user_id" {}
variable "dr_fingerprint" {}
variable "dr_private_key_path" {}
variable "dr_region" {}

# Default variables
variable "default_values" {
  type = object({
    default_compartment_id = string,
    default_defined_tags   = map(string),
    default_freeform_tags  = map(string),
    export_options = map(object({
      source                         = string,
      access                         = string,
      anonymous_gid                  = number,
      anonymous_uid                  = number,
      identity_squash                = string,
      require_privileged_source_port = string
    }))
  })
}

# Primary File Storage Config Variable
variable "file_storage_config_primary" {
  type = object({
    default_ad = string,
    file_systems = map(object({
      ad             = string,
      compartment_id = string,
      defined_tags   = map(string),
      freeform_tags  = map(string)
    })),
    mount_targets = map(object({
      ad             = string,
      subnet_id      = string,
      hostname_label = string,
      ip_address     = string,
      compartment_id = string,
      defined_tags   = map(string),
      freeform_tags  = map(string),
      export_set = object({
        max_fs_stat_bytes = number,
        max_fs_stat_files = number
      }),
      file_systems = map(object({
        path          = string,
        export_option = string
      }))
    }))
  })
}

# DR File Storage Config Variable
variable "file_storage_config_dr" {
  type = object({
    default_ad = string,
    file_systems = map(object({
      ad             = string,
      compartment_id = string,
      defined_tags   = map(string),
      freeform_tags  = map(string)
    })),
    mount_targets = map(object({
      ad             = string,
      subnet_id      = string,
      hostname_label = string,
      ip_address     = string,
      compartment_id = string,
      defined_tags   = map(string),
      freeform_tags  = map(string),
      export_set = object({
        max_fs_stat_bytes = number,
        max_fs_stat_files = number
      }),
      file_systems = map(object({
        path          = string,
        export_option = string
      }))
    }))
  })
}