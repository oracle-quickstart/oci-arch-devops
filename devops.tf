resource "oci_logging_log_group" "test_log_group" {
  compartment_id = var.compartment_id
  display_name   = "${local.app_name_normalized}_${random_string.deploy_id.result}_log_group"
}

resource "oci_logging_log" "test_log" {
    #Required
    display_name = "${local.app_name_normalized}_${random_string.deploy_id.result}_log"
    log_group_id = oci_logging_log_group.test_log_group.id
    log_type = "SERVICE"

    #Optional
    configuration {
        #Required
        source {
            #Required
            category = "all"
            resource = oci_devops_project.test_project.id
            service = "devops"
            source_type = "OCISERVICE"
        }

        #Optional
        compartment_id = var.compartment_id
    }
    
    is_enabled = true
    retention_duration = var.project_logging_config_retention_period_in_days
}

resource "oci_ons_notification_topic" "test_notification_topic" {
  compartment_id = var.compartment_id
  name           = var.notification_topic_name
}

resource "oci_devops_project" "test_project" {
  compartment_id = var.compartment_id
  # logging_config {
  #   log_group_id             = oci_logging_log_group.test_log_group.id
  #   retention_period_in_days = var.project_logging_config_retention_period_in_days
  # }

  name   = "${local.app_name_normalized}_${random_string.deploy_id.result}"
  notification_config {
    #Required
    topic_id = oci_ons_notification_topic.test_notification_topic.id
  }
  #  LOgging config missing- Add that 

  #Optional
  description = var.project_description
  #freeform_tags = var.project_freeform_tags
}

resource "oci_devops_deploy_environment" "test_environment" {
  display_name            = "test_oke_env"
  description             = "test oke based enviroment"
  deploy_environment_type = "OKE_CLUSTER"
  project_id              = oci_devops_project.test_project.id
  cluster_id              = oci_containerengine_cluster.oke_cluster[0].id

  // this should not be required ???
  //region=var.region
}

#  Add var to choose between an existing Articat and an inline one

resource "oci_devops_deploy_artifact" "test_deploy_artifact" {
  argument_substitution_mode = var.argument_substitution_mode
  deploy_artifact_type       = var.deploy_artifact_type
  project_id                 = oci_devops_project.test_project.id

  deploy_artifact_source {
    deploy_artifact_source_type = var.deploy_artifact_source_type #INLINE,GENERIC_ARTIFACT_OCIR
    base64encoded_content       = filebase64("${path.module}/manifest/nginx.yaml")
  }

}

resource "oci_devops_deploy_pipeline" "test_deploy_pipeline" {
  #Required
  project_id   = oci_devops_project.test_project.id
  description  = var.deploy_pipeline_description
  display_name = var.deploy_pipeline_display_name
  #Optional
  # defined_tags = {"foo-namespace.bar-key"= "value"}
  # deploy_pipeline_parameters {
  # 	#Required
  # 	items {
  # 		#Required
  # 		name = var.deploy_pipeline_deploy_pipeline_parameters_items_name

  # 		#Optional
  # 		default_value = var.deploy_pipeline_deploy_pipeline_parameters_items_default_value
  # 		description = var.deploy_pipeline_deploy_pipeline_parameters_items_description
  # 	}
  # }

  #freeform_tags = {"bar-key"= "value"}
}

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


  description  = var.deploy_stage_description
  display_name = var.deploy_stage_display_name

  kubernetes_manifest_deploy_artifact_ids = [oci_devops_deploy_artifact.test_deploy_artifact.id]
  namespace                               = var.deploy_stage_namespace
  oke_cluster_deploy_environment_id       = oci_devops_deploy_environment.test_environment.id

}

# data "oci_devops_projects" "test_projects" {
#   #Required
#   compartment_id = var.compartment_id

#   #Optional
#   //id    = var.project_id
#   name  = var.project_name
#   state = var.project_state
# }
