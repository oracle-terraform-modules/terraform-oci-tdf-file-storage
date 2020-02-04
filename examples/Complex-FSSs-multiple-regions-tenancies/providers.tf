# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

provider "oci" {
  alias            = "primary"
  tenancy_ocid     = "${var.primary_tenancy_id}"
  user_ocid        = "${var.primary_user_id}"
  fingerprint      = "${var.primary_fingerprint}"
  private_key_path = "${var.primary_private_key_path}"
  region           = "${var.primary_region}"
}

provider "oci" {
  alias            = "dr"
  tenancy_ocid     = "${var.dr_tenancy_id}"
  user_ocid        = "${var.dr_user_id}"
  fingerprint      = "${var.dr_fingerprint}"
  private_key_path = "${var.dr_private_key_path}"
  region           = "${var.dr_region}"
}