terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "test-bucket2344242"
    region     = "ru-central1"
    key        = "test-bucket/remote-state.tfstate"
    access_key = "Your S3 access key ID"
    secret_key = "Your S3 access secret"

    skip_region_validation      = true
    skip_credentials_validation = true
  }

}