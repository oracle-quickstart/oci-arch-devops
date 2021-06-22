## Copyright (c) 2020, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_functions_application" "test_fn_app" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.app_name}App"
  subnet_ids     = [oci_core_subnet.fnsubnet.id]
}

resource "oci_functions_function" "test_fn" {
  depends_on     = [null_resource.FnPush2OCIR]
  application_id = oci_functions_application.test_fn_app.id
  display_name   = var.app_name
  image          = "${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/${local.app_name_lower}:${var.app_version}"
  memory_in_mbs  = "256"
}

