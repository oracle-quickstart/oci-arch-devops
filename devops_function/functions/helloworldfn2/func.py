#
# oci-load-file-into-adw-python version 1.0.
#
# Copyright (c) 2020 Oracle, Inc.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
#

import io
import json
import requests

from fdk import response


def handler(ctx, data: io.BytesIO=None):

    return response.Response(
        ctx, 
        response_data=json.dumps({"status": "Hello World! Version 0.0.2"}),
        headers={"Content-Type": "application/json"}
    )
