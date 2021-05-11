# Copyright (c) 2021 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 
resource "oci_core_virtual_network" "wpmdsvcn" {
  cidr_block = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name = var.vcn
  dns_label = "wordpress"
}


resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name = "internet_gateway"
  vcn_id = oci_core_virtual_network.wpmdsvcn.id
}

resource "oci_core_route_table" "public_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_virtual_network.wpmdsvcn.id
  display_name = "RouteTableForWordPress"
  route_rules {
    cidr_block = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
  }
}


resource "oci_core_security_list" "public_security_list" {
  compartment_id = var.compartment_ocid
  display_name = "Allow Public SSH Connections to WordPress"
  vcn_id = oci_core_virtual_network.wpmdsvcn.id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
}

resource "oci_core_security_list" "public_security_list_http" {
  compartment_id = var.compartment_ocid
  display_name = "Allow HTTP(S) to WordPress"
  vcn_id = oci_core_virtual_network.wpmdsvcn.id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 80
      min = 80
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    tcp_options {
      max = 443
      min = 443
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
}

resource "oci_core_subnet" "public" {
  cidr_block = cidrsubnet(var.vcn_cidr, 8, 0)
  display_name = "wordpress_public_subnet"
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_virtual_network.wpmdsvcn.id
  route_table_id = oci_core_route_table.public_route_table.id
  security_list_ids = [oci_core_security_list.public_security_list.id, oci_core_security_list.public_security_list_http.id]
  dhcp_options_id = oci_core_virtual_network.wpmdsvcn.default_dhcp_options_id
  dns_label = "wp"
}