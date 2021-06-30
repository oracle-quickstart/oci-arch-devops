## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_logging_log_group" "test_log_group" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.app_name}_${random_string.deploy_id.result}_log_group"
}

resource "oci_logging_log" "test_log" {
  display_name = "${var.app_name}_${random_string.deploy_id.result}_log"
  log_group_id = oci_logging_log_group.test_log_group.id
  log_type     = "SERVICE"

  configuration {
    source {
      category    = "all"
      resource    = oci_devops_project.test_project.id
      service     = "devops"
      source_type = "OCISERVICE"
    }
    compartment_id = var.compartment_ocid
  }

  is_enabled         = true
  retention_duration = var.project_logging_config_retention_period_in_days
}

resource "oci_ons_notification_topic" "test_notification_topic" {
  compartment_id = var.compartment_ocid
  name           = "${var.app_name}_${random_string.deploy_id.result}_topic"
}

resource "oci_devops_project" "test_project" {
  compartment_id = var.compartment_ocid
  name           = "${var.app_name}_${random_string.deploy_id.result}_devops_project"
  notification_config {
    topic_id = oci_ons_notification_topic.test_notification_topic.id
  }
  description = "${var.app_name}_${random_string.deploy_id.result}_devops_project"
}

resource "oci_devops_deploy_environment" "test_environment" {
  display_name            = "${var.app_name}_${random_string.deploy_id.result}_devops_environment"
  description             = "${var.app_name}_${random_string.deploy_id.result}_devops_environment"
  deploy_environment_type = "FUNCTION"
  project_id              = oci_devops_project.test_project.id
  function_id             = oci_functions_function.test_fn.id
}

resource "oci_devops_deploy_artifact" "test_deploy_ocir_artifact" {
  depends_on                 = [null_resource.FnPush2OCIR2]
  project_id                 = oci_devops_project.test_project.id
  deploy_artifact_type       = var.deploy_artifact_type
  argument_substitution_mode = var.argument_substitution_mode
  deploy_artifact_source {
    deploy_artifact_source_type = var.deploy_artifact_source_type
    image_uri                   = "${local.ocir_docker_repository}/${local.ocir_namespace}/${var.ocir_repo_name}/${local.app_name_lower}:${var.app_version2}"
  }
}

resource "oci_devops_deploy_pipeline" "test_deploy_pipeline" {
  project_id   = oci_devops_project.test_project.id
  description  = "${var.app_name}_${random_string.deploy_id.result}_devops_pipeline"
  display_name = "${var.app_name}_${random_string.deploy_id.result}_devops_pipeline"

  deploy_pipeline_parameters {
    items {
      name          = var.deploy_pipeline_deploy_pipeline_parameters_items_name
      default_value = var.deploy_pipeline_deploy_pipeline_parameters_items_default_value
      description   = var.deploy_pipeline_deploy_pipeline_parameters_items_description
    }
  }
}

resource "oci_devops_deploy_stage" "test_deploy_stage" {
  deploy_pipeline_id = oci_devops_deploy_pipeline.test_deploy_pipeline.id
  deploy_stage_predecessor_collection {
    items {
      id = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    }
  }
  deploy_stage_type = var.deploy_stage_deploy_stage_type


  description  = "${var.app_name}_${random_string.deploy_id.result}_devops_deploy_stage"
  display_name = "${var.app_name}_${random_string.deploy_id.result}_devops_deploy_stage"

  namespace                       = var.deploy_stage_namespace
  function_deploy_environment_id  = oci_devops_deploy_environment.test_environment.id
  docker_image_deploy_artifact_id = oci_devops_deploy_artifact.test_deploy_ocir_artifact.id
}

resource "oci_devops_deployment" "test_deployment" {
  depends_on         = [null_resource.FnPush2OCIR2, oci_devops_deploy_stage.test_deploy_stage]
  deploy_pipeline_id = oci_devops_deploy_pipeline.test_deploy_pipeline.id
  deployment_type    = "PIPELINE_DEPLOYMENT"
  display_name       = "${var.app_name}_${random_string.deploy_id.result}_devops_deployment"
}
