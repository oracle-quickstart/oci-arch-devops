## Copyright (c) 2021, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
#variable "user_ocid" {}
#variable "fingerprint" {}
#variable "private_key_path" {}
variable "region" {}
variable "ssh_public_key" {
  default = ""
}

variable "execute_deployment" {
  default = false
}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.0"
}

variable "availablity_domain_name" {
  default = ""
}
variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "Subnet-CIDR" {
  default = "10.0.1.0/24"
}

variable "instance_shape" {
  description = "Instance Shape"
  default     = "VM.Standard.E3.Flex"
}

variable "instance_ocpus" {
  default = 1
}

variable "instance_shape_config_memory_in_gbs" {
  default = 1
}

variable "instance_os" {
  description = "Operating system for compute instances"
  default     = "Oracle Linux"
}

variable "linux_os_version" {
  description = "Operating system version for all Linux instances"
  default     = "7.9"
}

variable "create_dynamic_group_for_devops_pipln_in_compartment" {
  default = true
}

variable "project_logging_config_retention_period_in_days" {
  default = 30
}

variable "project_description" {
  default = "DevOps Project for Instance Group deployment"
}

variable "argument_substitution_mode" {
  default = "NONE"
}

variable "environment_type" {
  default = "COMPUTE_INSTANCE_GROUP"
}

variable "deploy_stage_namespace" {
  default = "default"
}

variable "filename" {
  default = "script.sh"
}

variable "deploy_stage_deploy_stage_type" {
  default = "COMPUTE_INSTANCE_GROUP_ROLLING_DEPLOYMENT"
}
