## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Functions Policies

resource "oci_identity_policy" "faas_read_repos_tenancy_policy" {
  provider       = oci.home_region
  name           = "${var.app_name}-faas-read-repos-tenancy-policy-${random_id.tag.hex}"
  description    = "${var.app_name}-faas-read-repos-tenancy-policy-${random_id.tag.hex}"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow service FaaS to read repos in tenancy"]
  provisioner "local-exec" {
    command = "sleep 5"
  }
}

resource "oci_identity_policy" "admin_manage_function_family_policy" {
  provider       = oci.home_region
  depends_on     = [oci_identity_policy.faas_read_repos_tenancy_policy]
  name           = "${var.app_name}-admin-manage-function-family-policy-${random_id.tag.hex}"
  description    = "${var.app_name}-admin-manage-function-family-policy-${random_id.tag.hex}"
  compartment_id = var.compartment_ocid
  statements = ["Allow group Administrators to manage functions-family in compartment id ${var.compartment_ocid}",
  "Allow group Administrators to read metrics in compartment id ${var.compartment_ocid}"]
  provisioner "local-exec" {
    command = "sleep 5"
  }
}

resource "oci_identity_policy" "admin_use_vcn_family_policy" {
  provider       = oci.home_region
  depends_on     = [oci_identity_policy.admin_manage_function_family_policy]
  name           = "${var.app_name}-admin-use-vcn-family-policy-${random_id.tag.hex}"
  description    = "${var.app_name}-admin-use-vcn-family-policy-${random_id.tag.hex}"
  compartment_id = var.compartment_ocid
  statements     = ["Allow group Administrators to use virtual-network-family in compartment id ${var.compartment_ocid}"]

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

resource "oci_identity_policy" "faas_use_vcn_family_policy" {
  provider       = oci.home_region
  depends_on     = [oci_identity_policy.admin_use_vcn_family_policy]
  name           = "${var.app_name}-faas-use-vcn-family-policy-${random_id.tag.hex}"
  description    = "${var.app_name}-faas-use-vcn-family-policy-${random_id.tag.hex}"
  compartment_id = var.tenancy_ocid
  statements     = ["Allow service FaaS to use virtual-network-family in compartment id ${var.compartment_ocid}"]

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

resource "oci_identity_dynamic_group" "faas_dg" {
  provider       = oci.home_region
  depends_on     = [oci_identity_policy.faas_use_vcn_family_policy]
  name           = "${var.app_name}-faas-dg-${random_id.tag.hex}"
  description    = "${var.app_name}-faas-dg-${random_id.tag.hex}"
  compartment_id = var.tenancy_ocid
  matching_rule  = "ALL {resource.type = 'fnfunc', resource.compartment.id = '${var.compartment_ocid}'}"

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

resource "oci_identity_policy" "faas_dg_policy" {
  provider       = oci.home_region
  depends_on     = [oci_identity_dynamic_group.faas_dg]
  name           = "${var.app_name}-faas-dg-policy-${random_id.tag.hex}"
  description    = "${var.app_name}-faas-dg-policy-${random_id.tag.hex}"
  compartment_id = var.compartment_ocid
  statements     = ["allow dynamic-group ${oci_identity_dynamic_group.faas_dg.name} to manage all-resources in compartment id ${var.compartment_ocid}"]

  provisioner "local-exec" {
    command = "sleep 5"
  }
}
