# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#########################
## File Storage
#########################

output "file_systems" {
  description = "File Systems:"
  value       = module.oci_file_storage_service.file_storage_config.file_systems
}

output "mount_targets" {
  description = "Mount Targets:"
  value = { for mt in module.oci_file_storage_service.file_storage_config.mount_targets : mt.display_name => {
    display_name      = mt.display_name,
    state             = mt.state,
    export_set_name   = mt.export_sets[keys(mt.export_sets)[0]].display_name
    max_fs_stat_bytes = mt.export_sets[keys(mt.export_sets)[0]].max_fs_stat_bytes
    max_fs_stat_files = mt.export_sets[keys(mt.export_sets)[0]].max_fs_stat_files
    file_systems      = { for export in mt.export_sets[keys(mt.export_sets)[0]].exports : "${export.file_system_name}" => export.path }
    }
  }
}