## Copyright (c) 2020, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Create group, user and polcies for devops service

resource "oci_identity_group" "devops" {
  name           = "devops-group"
  description    = "group created for devops"
  compartment_id = var.tenancy_ocid
}

resource "oci_identity_user" "devopsuser" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "user for devops"
    name = "devops-user"
}

resource "oci_identity_user_group_membership" "usergroupmem1" {
  depends_on     = [oci_identity_group.devops]
  group_id       = oci_identity_group.devops.id
  user_id        = oci_identity_user.devopsuser.id
}

resource "oci_identity_dynamic_group" "devopsgroup" {
  name           = "devopsdyngroup"
  description    = "DevOps Pipeline Dynamic Group"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ALL {resource.type = 'devopsdeploypipeline', resource.compartment.id = '${var.compartment_ocid}'}"
}

resource "oci_identity_dynamic_group" "runcmddynamicgroup" {
  name           = "run_cmd_dyn_group"
  description    = "run_cmd Pipeline Dynamic Group"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ANY {instance.id = '${oci_core_instance.compute_instance.id}'}"
}

resource "oci_identity_policy" "devopspolicy" {
  name           = "devops-policies"
  description    = "policy created for devops"
  compartment_id = var.compartment_ocid

  statements = [
    "Allow group ${oci_identity_group.devops.name} to manage devops-family in compartment id ${var.compartment_ocid}",
    "Allow group ${oci_identity_group.devops.name} to manage all-artifacts in compartment id ${var.compartment_ocid}",
    "Allow group ${oci_identity_group.devops.name} to manage instance-agent-command-execution-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.devopsgroup.name} to manage all-resources in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.runcmddynamicgroup.name} to manage instance-agent-command-execution-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.runcmddynamicgroup.name} to manage buckets in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.runcmddynamicgroup.name} to manage objects in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.runcmddynamicgroup.name} to manage generic-artifacts in compartment id ${var.compartment_ocid}",
  ]
}