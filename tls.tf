# Copyright (c) 2021 Oracle and/or its affiliates. All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl.
# 
resource "tls_private_key" "public_private_key_pair" {
  algorithm = "RSA"
}
