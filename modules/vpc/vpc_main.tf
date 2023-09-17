
terraform {
    required_providers {
        restapi = { source = "Mastercard/restapi" }
    }
}

# data "restapi_object" "my_vpc" {
#     path = "/vpcs"
#     search_key="name"
#     search_value="${var.vpc_name}"
#     results_key="vpcs"
# }


resource "restapi_object" "bl_vpc" {
  path = "/vpcs"
  id_attribute = "vpc/id"
  data = <<EOJ
        {
            "name": "${var.vpc_name}",
            "ip_range": "${var.vpc_ip_range}"
        }
    EOJ
}
