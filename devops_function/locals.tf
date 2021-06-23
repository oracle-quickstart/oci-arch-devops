locals {
  devops_compartment_statements = concat(
    local.allow_devops_manage_compartment_statements,
  )
}

locals {
  app_name_lower = lower(var.app_name)
}
