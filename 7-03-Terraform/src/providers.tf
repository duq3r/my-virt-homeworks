# Provider
provider "yandex" {
  service_account_key_file = "key.json"
 # token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  zone      = var.yc_region
}

