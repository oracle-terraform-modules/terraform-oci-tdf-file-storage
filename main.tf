# Copyright (c) 2020 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

locals {

  #################
  # File system service
  #################
  # default values

  default_file_system = {
    ad             = null
    compartment_id = null
    defined_tags   = {}
    display_name   = "shared_file_system"
    freeform_tags  = { "Department" = "Storage" }
    ad             = "1"
    mount_target = {
      subnet_id      = null
      display_name   = "mount_target"
      hostname_label = null
      ip_address     = null
      export_set = {
        display_name      = "export_set"
        max_fs_stat_bytes = null
        max_fs_stat_files = null
        export = {
          path = "/my_share"
          export_options = {
            source                         = "0.0.0.0/0"
            access                         = "READ_WRITE"
            anonymous_gid                  = null
            anonymous_uid                  = null
            identity_squash                = "NONE"
            require_privileged_source_port = "false"
          }
        }
      }
    }
  }

  keys_mount_targets = var.file_storage_config != null ? (var.file_storage_config.mount_targets != null ? keys(var.file_storage_config.mount_targets) : keys({})) : keys({})

  export_sets = {
    for mt_index in range(length(local.keys_mount_targets)) : "${local.keys_mount_targets[mt_index]}-export-set" => {
      max_fs_stat_bytes = var.file_storage_config.mount_targets[local.keys_mount_targets[mt_index]].export_set.max_fs_stat_bytes,
      max_fs_stat_files = var.file_storage_config.mount_targets[local.keys_mount_targets[mt_index]].export_set.max_fs_stat_files
    }
  }

  exports_list = distinct(flatten([
    for mt_index in range(length(local.keys_mount_targets)) : var.file_storage_config.mount_targets[local.keys_mount_targets[mt_index]].file_systems != null ? (length(var.file_storage_config.mount_targets[local.keys_mount_targets[mt_index]].file_systems) > 0 ? [
      for fs_name in keys(var.file_storage_config.mount_targets[local.keys_mount_targets[mt_index]].file_systems) : [{
        name          = "${local.keys_mount_targets[mt_index]}_${fs_name}_es1_e1",
        path          = var.file_storage_config.mount_targets[local.keys_mount_targets[mt_index]].file_systems[fs_name].path,
        export_option = var.file_storage_config.mount_targets[local.keys_mount_targets[mt_index]].file_systems[fs_name].export_option,
        mount_target  = local.keys_mount_targets[mt_index], file_system = fs_name
      }]
    ] : []) : []
  ]))

  exports = {
    for export in local.exports_list : export.name => {
      name          = export.name,
      export_option = export.export_option,
      file_system   = export.file_system,
      mount_target  = export.mount_target,
      path          = export.path
    }
  }
}
resource "oci_file_storage_file_system" "file_systems" {
  for_each = var.file_storage_config != null ? (var.file_storage_config.file_systems != null ? var.file_storage_config.file_systems : {}) : {}
  provider = "oci.custom_provider"

  #Required
  availability_domain = each.value.ad != null ? lookup(data.oci_identity_availability_domains.this[0].availability_domains[each.value.ad - 1], "name") : lookup(data.oci_identity_availability_domains.this[0].availability_domains[(var.file_storage_config.default_ad != null ? var.file_storage_config.default_ad : local.default_file_system.ad) - 1], "name")
  compartment_id      = each.value.compartment_id != null ? each.value.compartment_id : (var.file_storage_config.default_compartment_id != null ? var.file_storage_config.default_compartment_id : local.default_file_system.compartment_id)

  #Optional
  defined_tags  = each.value.defined_tags != null ? each.value.defined_tags : (var.file_storage_config.default_defined_tags != null ? var.file_storage_config.default_defined_tags : local.default_file_system.defined_tags)
  display_name  = each.key
  freeform_tags = each.value.freeform_tags != null ? each.value.freeform_tags : (var.file_storage_config.default_freeform_tags != null ? var.file_storage_config.default_freeform_tags : local.default_file_system.freeform_tags)
}

resource "oci_file_storage_mount_target" "mount_targets" {

  for_each = var.file_storage_config != null ? (var.file_storage_config.mount_targets != null ? var.file_storage_config.mount_targets : {}) : {}
  provider = "oci.custom_provider"

  #Required
  availability_domain = each.value.ad != null ? lookup(data.oci_identity_availability_domains.this[0].availability_domains[each.value.ad - 1], "name") : lookup(data.oci_identity_availability_domains.this[0].availability_domains[(var.file_storage_config.default_ad != null ? var.file_storage_config.default_ad : local.default_file_system.ad) - 1], "name")
  compartment_id      = each.value.compartment_id != null ? each.value.compartment_id : (var.file_storage_config.default_compartment_id != null ? var.file_storage_config.default_compartment_id : local.default_file_system.compartment_id)
  subnet_id           = each.value.subnet_id

  #Optional
  defined_tags   = each.value.defined_tags != null ? each.value.defined_tags : (var.file_storage_config.default_defined_tags != null ? var.file_storage_config.default_defined_tags : local.default_file_system.defined_tags)
  display_name   = each.key
  freeform_tags  = each.value.freeform_tags != null ? each.value.freeform_tags : (var.file_storage_config.default_freeform_tags != null ? var.file_storage_config.default_freeform_tags : local.default_file_system.freeform_tags)
  hostname_label = each.value.hostname_label
  ip_address     = each.value.ip_address
}

resource "oci_file_storage_export_set" "export_sets" {
  provider = "oci.custom_provider"
  for_each = var.file_storage_config != null ? (var.file_storage_config.mount_targets != null ? local.export_sets : {}) : {}
  #Required
  mount_target_id = [for mt in oci_file_storage_mount_target.mount_targets : mt.id if(mt.display_name == [for mt_index in range(length(local.keys_mount_targets)) : local.keys_mount_targets[mt_index] if "${local.keys_mount_targets[mt_index]}-export-set" == each.key][0])][0]

  #Optional
  display_name      = each.key
  max_fs_stat_bytes = each.value.max_fs_stat_bytes
  max_fs_stat_files = each.value.max_fs_stat_files
}

resource "oci_file_storage_export" "exports" {
  provider = "oci.custom_provider"
  for_each = var.file_storage_config != null ? (local.exports != null ? local.exports : {}) : {}
  #Required
  export_set_id  = [for es in oci_file_storage_export_set.export_sets : es.id if es.display_name == "${each.value.mount_target}-export-set"][0]
  file_system_id = [for fs in oci_file_storage_file_system.file_systems : fs.id if fs.display_name == each.value.file_system][0]
  path           = each.value.path != null ? each.value.path : local.default_file_system.mount_target.export_set.export.path


  #Optional
  export_options {
    #Required

    source = var.file_storage_config.export_options[each.value.export_option].source != null ? var.file_storage_config.export_options[each.value.export_option].source : local.default_file_system.mount_target.export_set.export.export_options.source

    #Optional
    access                         = var.file_storage_config.export_options[each.value.export_option].access != null ? var.file_storage_config.export_options[each.value.export_option].access : local.default_file_system.mount_target.export_set.export.export_options.access
    anonymous_gid                  = var.file_storage_config.export_options[each.value.export_option].anonymous_gid
    anonymous_uid                  = var.file_storage_config.export_options[each.value.export_option].anonymous_uid
    identity_squash                = var.file_storage_config.export_options[each.value.export_option].identity_squash != null ? var.file_storage_config.export_options[each.value.export_option].identity_squash : local.default_file_system.mount_target.export_set.export.export_options.identity_squash
    require_privileged_source_port = var.file_storage_config.export_options[each.value.export_option].require_privileged_source_port != null ? var.file_storage_config.export_options[each.value.export_option].require_privileged_source_port : local.default_file_system.mount_target.export_set.export.export_options.require_privileged_source_port
  }
}

