resource "oci_logging_log_group" "test_log_group" {
    compartment_id = var.compartment_id
    display_name = var.log_group_display_name
}

resource "oci_ons_notification_topic" "test_notification_topic" {
    compartment_id = var.compartment_id
    name = var.notification_topic_name
}

resource "oci_devops_project" "test_project" {
  compartment_id = var.compartment_id
  logging_config {
    log_group_id             = oci_logging_log_group.test_log_group.id
    retention_period_in_days = var.project_logging_config_retention_period_in_days

    #Optional
    display_name_prefix  = var.project_logging_config_display_name_prefix
    is_archiving_enabled = var.project_logging_config_is_archiving_enabled
  }
  name = var.project_name
  notification_config {
    #Required
    topic_id = oci_ons_notification_topic.test_notification_topic.id
  }

  #Optional
  description   = var.project_description
  freeform_tags = var.project_freeform_tags
}

data "oci_devops_projects" "test_projects" {
  #Required
  compartment_id = var.compartment_id

  #Optional
  id    = var.project_id
  name  = var.project_name
  state = var.project_state
}