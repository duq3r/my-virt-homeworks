# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "b1geim0buhe7h6mvpbtr"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1gc0if4fp4krujvnc5u"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
variable "centos-7-base" {
  default = "fd8i72iv2qovq8mkd84k"
}

#Дополнительно необходимо получить файл key.json
# yc iam key create --service-account-name default-sa --output key.json --folder-id <ID каталога>
#Если нет сервисного аккаунта, то необходимо создать его предварительно
#terraform apply --auto-approve
#terraform destroy --auto-approve