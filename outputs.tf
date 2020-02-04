# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

output "file_storage_config" {
  description = "The returned resource attributes for the file system and its artefacts"
  value = {
    file_systems = { for x in oci_file_storage_file_system.file_systems : x.display_name => {
      display_name        = x.display_name,
      availability_domain = x.availability_domain,
      compartment_id      = x.compartment_id,
      defined_tags        = x.defined_tags,
      freeform_tags       = x.freeform_tags,
      id                  = x.id,
      metered_bytes       = x.metered_bytes,
      state               = x.state,
      time_created        = x.time_created
      }
    },
    mount_targets = { for y in oci_file_storage_mount_target.mount_targets : y.display_name => {
      display_name        = y.display_name,
      availability_domain = y.availability_domain,
      compartment_id      = y.compartment_id,
      defined_tags        = y.defined_tags,
      freeform_tags       = y.freeform_tags,
      export_set_id       = y.export_set_id,
      hostname_label      = y.hostname_label,
      id                  = y.id,
      lifecycle_details   = y.lifecycle_details,
      private_ip_ids      = y.private_ip_ids,
      state               = y.state,
      subnet_id           = y.subnet_id,
      time_created        = y.time_created,
      export_sets = { for z in oci_file_storage_export_set.export_sets : z.display_name => {
        availability_domain = z.availability_domain,
        compartment_id      = z.compartment_id,
        display_name        = z.display_name,
        id                  = z.id,
        max_fs_stat_bytes   = z.max_fs_stat_bytes,
        max_fs_stat_files   = z.max_fs_stat_files,
        mount_target_id     = z.mount_target_id,
        state               = z.state,
        time_created        = z.time_created,
        vcn_id              = z.vcn_id,
        exports = [for w in oci_file_storage_export.exports : { export_options = w.export_options,
          export_set_id    = w.export_set_id,
          export_set_name  = z.display_name,
          file_system_id   = w.file_system_id,
          file_system_name = [for fs in oci_file_storage_file_system.file_systems : fs.display_name if fs.id == w.file_system_id][0]
          id               = w.id,
          path             = w.path,
          state            = w.state,
          time_created     = w.time_created
        } if w.export_set_id == z.id]
        } if contains([for w2 in oci_file_storage_export.exports : w2.export_set_id if w2.export_set_id == y.export_set_id && w2.export_set_id == z.id], z.id)
      }
      }
    }
  }
}

