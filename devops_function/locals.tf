locals {
  devops_compartment_statements = concat(
    local.allow_devops_manage_compartment_statements,
  )
}

locals {
  devops_pipln_dg = var.create_dynamic_group_for_devops_pipln_in_compartment ? oci_identity_dynamic_group.devops_pipln_dg.0.name : "void"
  allow_devops_manage_compartment_statements = [
    "Allow dynamic-group ${local.devops_pipln_dg} to manage all-resources in compartment id ${var.compartment_ocid}",
  ]

}

locals {
  app_name_lower = lower(var.app_name)
}
