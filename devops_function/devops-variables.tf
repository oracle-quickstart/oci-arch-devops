## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# Create Dynamic Group and Policies
variable "create_dynamic_group_for_nodes_in_compartment" {
  default = true
}
variable "existent_dynamic_group_for_nodes_in_compartment" {
  default = ""
}
variable "create_compartment_policies" {
  default = true
}
variable "create_tenancy_policies" {
  default = true
}

variable "deploy_pipeline_deploy_pipeline_parameters_items_default_value" {
  default = "defaultValue"
}

variable "deploy_pipeline_deploy_pipeline_parameters_items_description" {
  default = "description"
}

variable "deploy_pipeline_deploy_pipeline_parameters_items_name" {
  default = "name"
}

variable "project_description" {
  default = "description"
}
variable "environment_type" {
  default = "FUNCTION"
}

variable "project_logging_config_display_name_prefix" {
  default = "fn-"
}

variable "project_logging_config_is_archiving_enabled" {
  default = false
}

variable "project_logging_config_retention_period_in_days" {
  default = 30
}


variable "deploy_artifact_source_type" {
  default = "OCIR"
}

variable "deploy_artifact_type" {
  default = "DOCKER_IMAGE"
}

variable "argument_substitution_mode" {
  default = "NONE"
}

variable "create_dynamic_group_for_devops_pipln_in_compartment" {
  default = true
}

variable "deploy_stage_deploy_stage_type" {
  default = "DEPLOY_FUNCTION"
}

variable "deploy_stage_namespace" {
  default = "default"
}

