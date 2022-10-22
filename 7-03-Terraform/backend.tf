# terraform {
#   backend "s3" {
#     endpoint   = "storage.yandexcloud.net"
#     bucket     = "test-bucket"
#     region     = "ru-central1"
#     key        = "test-bucket/remote-state.tfstate"
#     access_key = "ajeh5k9dgm4dvgaambj7" #ID
#     secret_key = "AQVN0S0S2FiN_BSrLmfBV-ZE7r2SZpgBja9R701i"

#     skip_region_validation      = true
#     skip_credentials_validation = true
#   }


  # network_interface {
  #   subnet_id = data.terraform_remote_state.vpc.outputs.subnet-1
  #   nat       = true
  # }
#}