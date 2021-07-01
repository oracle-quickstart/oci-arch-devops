## Copyright (c) 2020, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# This Terraform script provisions a compute instance required for OCI DevOps service


resource "oci_core_instance" "compute_instance" {
  availability_domain = var.availablity_domain_name == "" ? data.oci_identity_availability_domains.ADs.availability_domains[0]["name"] : var.availablity_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "devops-instance"
  shape               = var.instance_shape
  fault_domain        = "FAULT-DOMAIN-1"

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_shape_config_memory_in_gbs
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key == "" ? tls_private_key.public_private_key_pair.public_key_openssh : var.ssh_public_key
    user_data           = base64encode(file("./userdata/bootstrap"))

  }

  create_vnic_details {
    subnet_id                 = oci_core_subnet.subnet.id
    display_name              = "primaryvnic"
    assign_public_ip          = true
    assign_private_dns_record = true
  }

  source_details {
    source_type             = "image"
    source_id               = lookup(data.oci_core_images.InstanceImageOCID.images[0], "id")
    boot_volume_size_in_gbs = "50"
  }

  timeouts {
    create = "60m"
  }
  defined_tags = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}
