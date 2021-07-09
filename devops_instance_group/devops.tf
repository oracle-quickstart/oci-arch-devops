## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Create Artifact Repository

resource "oci_artifacts_repository" "test_repository" {
  #Required
  compartment_id  = var.compartment_ocid
  is_immutable    = true
  repository_type = "GENERIC"
  defined_tags    = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Upload artifacts to repository

resource "oci_generic_artifacts_content_artifact_by_path" "test_artifact" {
  #Required
  artifact_path = var.filename
  repository_id = oci_artifacts_repository.test_repository.id
  version       = "1.0"
  content       = file("${path.module}/file/${var.filename}")
}

resource "oci_artifacts_generic_artifact" "test_generic_artifact" {
  artifact_id  = oci_generic_artifacts_content_artifact_by_path.test_artifact.id
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Create log and log group

resource "oci_logging_log_group" "test_log_group" {
  compartment_id = var.compartment_ocid
  display_name   = "devops_log_group_${random_string.deploy_id.result}"
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_logging_log" "test_log" {
  #Required
  display_name = "devops_log_group_log"
  log_group_id = oci_logging_log_group.test_log_group.id
  log_type     = "SERVICE"

  #Optional
  configuration {
    #Required
    source {
      #Required
      category    = "all"
      resource    = oci_devops_project.test_project.id
      service     = "devops"
      source_type = "OCISERVICE"
    }

    #Optional
    compartment_id = var.compartment_ocid
  }

  is_enabled         = true
  retention_duration = var.project_logging_config_retention_period_in_days
  defined_tags       = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Create OCI Notification

resource "oci_ons_notification_topic" "test_notification_topic" {
  compartment_id = var.compartment_ocid
  name           = "${random_string.deploy_id.result}_devopstopic"
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Create devops project

resource "oci_devops_project" "test_project" {
  compartment_id = var.compartment_ocid
  name           = "devopsproject_${random_string.deploy_id.result}"

  notification_config {
    #Required
    topic_id = oci_ons_notification_topic.test_notification_topic.id
  }

  #Optional
  description  = var.project_description
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Create environment for deployment - compute instance

resource "oci_devops_deploy_environment" "test_deploy_instance_group_environment" {
  compute_instance_group_selectors {
    items {
      compute_instance_ids = [oci_core_instance.compute_instance.id]
      selector_type        = "INSTANCE_IDS"
    }
  }
  deploy_environment_type = var.environment_type
  project_id              = oci_devops_project.test_project.id
  defined_tags            = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Create artifact to use

# Create deployment specification artifact to use

resource "oci_devops_deploy_artifact" "test_deploy_artifact" {
  argument_substitution_mode = var.argument_substitution_mode
  deploy_artifact_type       = "DEPLOYMENT_SPEC"
  project_id                 = oci_devops_project.test_project.id

  deploy_artifact_source {
    deploy_artifact_source_type = "INLINE"
    base64encoded_content       = file("${path.module}/manifest/spec.yaml")
  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Create application artifact to use

resource "oci_devops_deploy_artifact" "test_deploy_app_artifact" {
  argument_substitution_mode = var.argument_substitution_mode
  deploy_artifact_type       = "GENERIC_FILE"
  project_id                 = oci_devops_project.test_project.id

  deploy_artifact_source {
    deploy_artifact_source_type = "GENERIC_ARTIFACT"
    repository_id               = oci_artifacts_repository.test_repository.id
    deploy_artifact_version     = "1.0"
    deploy_artifact_path        = var.filename
  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Create deployment pipeline

resource "oci_devops_deploy_pipeline" "test_deploy_pipeline" {
  #Required
  project_id   = oci_devops_project.test_project.id
  description  = "devops demo pipleline"
  display_name = "devopspipeline"

  deploy_pipeline_parameters {
    items {
      name          = var.deploy_pipeline_deploy_pipeline_parameters_items_name
      default_value = var.deploy_pipeline_deploy_pipeline_parameters_items_default_value
      description   = var.deploy_pipeline_deploy_pipeline_parameters_items_description
    }
  }

  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Create deployment stages in the pipeline

resource "oci_devops_deploy_stage" "test_deploy_stage" {
  #Required
  deploy_pipeline_id = oci_devops_deploy_pipeline.test_deploy_pipeline.id
  deploy_stage_predecessor_collection {
    #Required
    items {
      #Required - firt statge has the predecessor ID as pipeline ID
      id = oci_devops_deploy_pipeline.test_deploy_pipeline.id
    }
  }
  deploy_stage_type = var.deploy_stage_deploy_stage_type


  description  = "deploy pipeline stage"
  display_name = "deployinstance"

  deployment_spec_deploy_artifact_id           = oci_devops_deploy_artifact.test_deploy_artifact.id
  deploy_artifact_ids                          = [oci_devops_deploy_artifact.test_deploy_app_artifact.id]
  namespace                                    = var.deploy_stage_namespace
  compute_instance_group_deploy_environment_id = oci_devops_deploy_environment.test_deploy_instance_group_environment.id

  rollout_policy {
    batch_count            = "5"
    batch_delay_in_seconds = "10"
    policy_type            = "COMPUTE_INSTANCE_GROUP_LINEAR_ROLLOUT_POLICY_BY_COUNT"
  }

  rollback_policy {
    policy_type = "AUTOMATED_STAGE_ROLLBACK_POLICY"
  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

# Invoke the deployment

resource "oci_devops_deployment" "test_deployment" {
  count      = var.execute_deployment ? 1 : 0
  depends_on = [oci_devops_deploy_stage.test_deploy_stage]
  #Required
  deploy_pipeline_id = oci_devops_deploy_pipeline.test_deploy_pipeline.id
  deployment_type    = "PIPELINE_DEPLOYMENT"

  #Optional
  display_name = "devopsdeployment"
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

