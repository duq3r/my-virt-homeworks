#Before building using packer build it's needed to add net and subnet. After that you need to delete it.
## Чтобы создать сеть перед созданием образа
yc vpc network create --name net && 
yc vpc subnet create --name my-subnet-a --zone ru-central1-a --range 10.1.2.0/24 --network-name net --description "my first subnet via yc"
## Чтобы удалить сеть после создания образа
yc vpc subnet delete --name my-subnet-a && yc vpc network delete --name net

yc compute image list

"folder_id": "b1gc0if4fp4krujvnc5u",   #The Folder ID or the namespace
"subnet_id": "",   #Subnet ID  (Network ID)

Чтобы запустить сборку образа:
packer build script-file.json