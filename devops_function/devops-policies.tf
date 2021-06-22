# Copyright (c) 2021 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 

resource "oci_identity_dynamic_group" "devops_pipln_dg" {
  count          = var.create_dynamic_group_for_devops_pipln_in_compartment ? 1 : 0
  provider       = oci.home_region
  compartment_id = var.tenancy_ocid
  name           = "${var.app_name}-devops-pipln-dg-${random_string.deploy_id.result}"
  description    = "${var.app_name} DevOps Pipeline Dynamic Group"
  matching_rule  = "All {resource.type = 'devopsdeploypipeline', resource.compartment.id = '${var.compartment_ocid}'}"
}

resource "oci_identity_policy" "devops_compartment_policies" {
  count          = var.create_compartment_policies ? 1 : 0
  depends_on     = [oci_identity_dynamic_group.devops_pipln_dg]
  provider       = oci.home_region
  name           = "${var.app_name}-devops-compartment-policies-${random_string.deploy_id.result}"
  description    = "${var.app_name} DevOps Compartment Policies"
  compartment_id = var.compartment_ocid
  statements     = local.devops_compartment_statements
}

