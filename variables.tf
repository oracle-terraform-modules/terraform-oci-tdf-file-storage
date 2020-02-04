# File Storage Config Variable
variable "file_storage_config" {
  type = object({
    default_compartment_id = string,
    default_defined_tags   = map(string),
    default_freeform_tags  = map(string),
    default_ad             = string
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
    })),
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