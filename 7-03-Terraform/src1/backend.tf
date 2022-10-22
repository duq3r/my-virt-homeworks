terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "test-bucket"
    region     = "ru-central1"
    key        = "test-bucket/remote-state.tfstate"
    access_key = "<static key ID>"
    secret_key = "<secret key>"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     = "<OAuth or static key of the service account>"
  cloud_id  = "<cloud ID>"
  folder_id = "<folder ID>"
  zone      = "<default availability zone>"
}

  network_interface {
    subnet_id = data.terraform_remote_state.vpc.outputs.subnet-1
    nat       = true
  }