# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

module "oci_file_storage_service" {

  source = "../../"

  providers = {
    oci.custom_provider = "oci"
  }

  file_storage_config = var.file_storage_config
}

