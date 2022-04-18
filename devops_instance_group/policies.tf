## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Create group, user and polcies for devops service

resource "oci_identity_group" "devops" {
  provider       = oci.home_region
  name           = "devops-group-${random_id.tag.hex}"
  description    = "group created for devops"
  compartment_id = var.tenancy_ocid
}

resource "oci_identity_user" "devopsuser" {
  #Required
  provider       = oci.home_region
  compartment_id = var.tenancy_ocid
  description    = "user for devops"
  name           = "devops-user-${random_id.tag.hex}"
}

resource "oci_identity_user_group_membership" "usergroupmem1" {
  depends_on = [oci_identity_group.devops]
  provider   = oci.home_region
  group_id   = oci_identity_group.devops.id
  user_id    = oci_identity_user.devopsuser.id
}

resource "oci_identity_dynamic_group" "devopsgroup" {
  provider       = oci.home_region
  name           = "devopsdyngroup-${random_id.tag.hex}"
  description    = "DevOps Pipeline Dynamic Group"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ALL {resource.type = 'devopsdeploypipeline', resource.compartment.id = '${var.compartment_ocid}'}"
}

resource "oci_identity_dynamic_group" "runcmddynamicgroup" {
  provider       = oci.home_region
  name           = "run_cmd_dyn_group-${random_id.tag.hex}"
  description    = "run_cmd Pipeline Dynamic Group"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ANY {instance.id = '${oci_core_instance.compute_instance.id}'}"
}

resource "oci_identity_policy" "devopspolicy" {
  provider       = oci.home_region
  name           = "devops-policies-${random_id.tag.hex}"
  description    = "policy created for devops"
  compartment_id = var.compartment_ocid

  statements = [
    "Allow group ${oci_identity_group.devops.name} to manage devops-family in compartment id ${var.compartment_ocid}",
    "Allow group ${oci_identity_group.devops.name} to manage all-artifacts in compartment id ${var.compartment_ocid}",
    "Allow group ${oci_identity_group.devops.name} to use instance-agent-command-execution-family in compartment id ${var.compartment_ocid} where request.instance.id=${oci_core_instance.compute_instance.id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.devopsgroup.name} to manage all-resources in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.runcmddynamicgroup.name} to use instance-agent-command-execution-family in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.runcmddynamicgroup.name} to manage buckets in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.runcmddynamicgroup.name} to manage objects in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.runcmddynamicgroup.name} to manage generic-artifacts in compartment id ${var.compartment_ocid}",
    "Allow dynamic-group ${oci_identity_dynamic_group.runcmddynamicgroup.name} to read all-artifacts in compartment id ${var.compartment_ocid}"
  ]
}
