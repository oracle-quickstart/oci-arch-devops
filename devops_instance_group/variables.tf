## Copyright (c) 2020, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "compartment_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "ssh_public_key" {}


# Specify any variable value's here

variable "instance_shape" {
  description = "Instance Shape"
  default     = "VM.Standard.E3.Flex"
}
variable "availability_domain" {
  default="3"
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
  default = "devops project"
}

variable "argument_substitution_mode" {
  default = "NONE"
}

variable "deploy_stage_namespace" {
  default = "default"
}

variable "filename" {
  default = "script.sh"
}
