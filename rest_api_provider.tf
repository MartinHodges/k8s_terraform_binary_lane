provider "restapi" {
  uri                  = "https://api.binarylane.com.au/v2"
  # uri = "http://localhost:8080/api/v1"
  write_returns_object = true
  debug                = true

  headers = {
    "Authorization" = "Bearer ${var.binarylane_api_key}",
    "Content-Type" = "application/json"
  }

  create_returns_object = true

  id_attribute = "id"

  create_method  = "POST"
  update_method  = ""
  destroy_method = "DELETE"
}
