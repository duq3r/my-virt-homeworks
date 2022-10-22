terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "test-bucket2344242"
    region     = "ru-central1"
    key        = "test-bucket/remote-state.tfstate"
    access_key = "YCAJEvSHDkjC39LyWGIzCbr55" #ID
    secret_key = "YCPXYCOR46e6m3e-y250aNVxaeK363zzhPH-N5zO"

    skip_region_validation      = true
    skip_credentials_validation = true
  }

}