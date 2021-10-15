## Copyright © 2021, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "random_id" "tag" {
  byte_length = 2
}

resource "oci_identity_tag_namespace" "ArchitectureCenterTagNamespace" {
  provider       = oci.home_region
  compartment_id = var.compartment_id
  description    = "ArchitectureCenterTagNamespace"
  name           = "ArchitectureCenter\\devops_oke-${random_id.tag.hex}"

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "oci_identity_tag" "ArchitectureCenterTag" {
  provider         = oci.home_region
  description      = "ArchitectureCenterTag"
  name             = "release"
  tag_namespace_id = oci_identity_tag_namespace.ArchitectureCenterTagNamespace.id

  validator {
    validator_type = "ENUM"
    values         = ["release", "1.2"]
  }

  provisioner "local-exec" {
    command = "sleep 120"
  }

}
