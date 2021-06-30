## Copyright (c) 2020, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "null_resource" "Login2OCIR" {
  depends_on = [oci_functions_application.test_fn_app,
    oci_identity_policy.faas_read_repos_tenancy_policy,
    oci_identity_policy.admin_manage_function_family_policy,
    oci_identity_dynamic_group.faas_dg,
  oci_identity_policy.faas_dg_policy]

  provisioner "local-exec" {
    command = "echo '${var.ocir_user_password}' |  docker login ${local.ocir_docker_repository} --username ${local.ocir_namespace}/${var.ocir_user_name} --password-stdin"
  }
}

resource "null_resource" "FnPush2OCIR" {
  depends_on = [null_resource.Login2OCIR, oci_functions_application.test_fn_app]

  provisioner "local-exec" {
    command     = "image=$(docker images | grep ${local.app_name_lower} | awk -F ' ' '{print $3}') ; docker rmi -f $image &> /dev/null ; echo $image"
    working_dir = "functions/${local.app_name_lower}"
  }

  provisioner "local-exec" {
    command     = "fn build --verbose"
    working_dir = "functions/${local.app_name_lower}"
  }

  provisioner "local-exec" {
    command     = "image=$(docker images | grep ${local.app_name_lower} | awk -F ' ' '{print $3}') ; docker tag $image ${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/${local.app_name_lower}:${var.app_version}"
    working_dir = "functions/${local.app_name_lower}"
  }

  provisioner "local-exec" {
    command     = "docker push ${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/${local.app_name_lower}:${var.app_version}"
    working_dir = "functions/${local.app_name_lower}"
  }

}

resource "null_resource" "FnPush2OCIR2" {
  depends_on = [null_resource.Login2OCIR, null_resource.FnPush2OCIR, oci_functions_function.test_fn]

  provisioner "local-exec" {
    command     = "image=$(docker images | grep ${local.app_name_lower} | awk -F ' ' '{print $3}') ; docker rmi -f $image &> /dev/null ; echo $image"
    working_dir = "functions/${local.app_name_lower}2"
  }

  provisioner "local-exec" {
    command     = "fn build --verbose"
    working_dir = "functions/${local.app_name_lower}2"
  }

  provisioner "local-exec" {
    command     = "image=$(docker images | grep ${local.app_name_lower} | awk -F ' ' '{print $3}') ; docker tag $image ${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/${local.app_name_lower}:${var.app_version2}"
    working_dir = "functions/${local.app_name_lower}2"
  }

  provisioner "local-exec" {
    command     = "docker push ${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/${local.app_name_lower}:${var.app_version2}"
    working_dir = "functions/${local.app_name_lower}2"
  }

}
