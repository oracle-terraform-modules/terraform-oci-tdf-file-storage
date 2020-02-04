# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

#########################
## FileSystems
#########################

output "file_storage_config_primary" {
  description = "Primary file_storage_config:"
  value       = module.primary_oci_file_storage_service.file_storage_config
}

output "file_storage_config_dr" {
  description = "DR file_storage_config:"
  value       = module.dr_oci_file_storage_service.file_storage_config
}

