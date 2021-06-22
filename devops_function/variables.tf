## Copyright (c) 2020, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}

variable "app_name" {
  default     = "HelloWorldFn"
  description = "Application name. Will be used as prefix to identify resources, such as Function, VCN, DevOps, and others"
}

variable "app_version" {
  default = "0.0.1"
}

# ORM Schema visual control variables
variable "show_advanced" {
  default = false
}


variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "fnsubnet-CIDR" {
  default = "10.0.1.0/24"
}

variable "ocir_repo_name" {
  default = "functions"
}

variable "ocir_user_name" {
  default = ""
}

variable "ocir_user_password" {
  default = ""
}

# OCIR repo name & namespace

locals {
  ocir_docker_repository = join("", [lower(lookup(data.oci_identity_regions.oci_regions.regions[0], "key")), ".ocir.io"])
  ocir_namespace         = lookup(data.oci_identity_tenancy.oci_tenancy, "name")
}
