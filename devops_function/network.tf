## Copyright (c) 2020, Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_virtual_network" "vcn" {
  cidr_block     = var.VCN-CIDR
  dns_label      = "vcn"
  compartment_id = var.compartment_ocid
  display_name   = "vcn"
}

resource "oci_core_internet_gateway" "igw" {
    compartment_id = var.compartment_ocid
    display_name   = "igw"
    vcn_id         = oci_core_virtual_network.vcn.id
}


resource "oci_core_route_table" "rt_via_igw" {
    compartment_id = var.compartment_ocid
    vcn_id         = oci_core_virtual_network.vcn.id
    display_name   = "rt_via_igw"
    route_rules {
        destination = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
        network_entity_id = oci_core_internet_gateway.igw.id
    }
}

resource "oci_core_dhcp_options" "dhcpoptions1" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_virtual_network.vcn.id
  display_name   = "dhcpoptions1"

  // required
  options {
    type = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }

  // optional
  options {
    type = "SearchDomain"
    search_domain_names = [ "example.com" ]
  }
}

resource "oci_core_subnet" "fnsubnet" {
  cidr_block        = var.fnsubnet-CIDR
  display_name      = "fnsubnet"
  dns_label         = "fnsub"
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_virtual_network.vcn.id
  route_table_id    = oci_core_route_table.rt_via_igw.id
  dhcp_options_id   = oci_core_dhcp_options.dhcpoptions1.id
  security_list_ids = [oci_core_virtual_network.vcn.default_security_list_id]
}

