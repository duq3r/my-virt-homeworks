terraform {


 
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "tf-state-bucket-test"
    region     = "ru-central1-a"
    key        = "terraform/infrastructure1/terraform.tfstate"
    access_key = "<access_key>"
    secret_key = "<secret_key >"
 
    skip_region_validation      = true
    skip_credentials_validation = true
  }
}