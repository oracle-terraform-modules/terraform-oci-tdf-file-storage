# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

######################
# Availability Domains
######################
data "oci_identity_availability_domains" "this" {
  provider       = "oci.custom_provider"
  count          = var.file_storage_config != null ? 1 : 0
  compartment_id = var.file_storage_config != null ? var.file_storage_config.default_compartment_id : "null"
}