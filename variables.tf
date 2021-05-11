variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_id" {}

variable "log_group_display_name" {
  default = "devops-logs"
}

variable "notification_topic_name" {
  default = "devops-topic"
}

variable "project_defined_tags_value" {
  default = "value"
}

variable "project_description" {
  default = "description"
}

variable "project_freeform_tags" {
  default = { "bar-key" = "value" }
}

variable "project_id" {
  default = "id"
}

variable "project_logging_config_display_name_prefix" {
  default = "demo-"
}

variable "project_logging_config_is_archiving_enabled" {
  default = false
}

variable "project_logging_config_retention_period_in_days" {
  default = 30
}

variable "project_name" {
  default = "demo-project"
}

variable "project_state" {
  default = "Active"
}
