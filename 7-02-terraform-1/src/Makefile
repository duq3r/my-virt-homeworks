ENV?=stage

all: init workspace plan apply pause #deploy

init:
	terraform init

workspace:
	terraform workspace new ${ENV}

set_workspace:
	terraform workspace select ${ENV}

plan: set_workspace
	terraform plan

apply: set_workspace
	terraform apply -auto-approve

destroy: set_workspace
	terraform destroy -auto-approve

clean:
	rm -f terraform.tfplan
	rm -f .terraform.lock.hcl
	rm -fr terraform.tfstate*
	rm -fr .terraform/

pause:
	echo "Wait for 60 seconds stupid Yandex Cloud creating a VM's..."
	sleep 60
# 	echo "May be created? Ok, run an ansible playbook..."
# deploy:
# 	cd ./ansible && source .env.news-app && ansible-playbook -i inventory/demo site.yml

# reconfig:
# 	cd ./ansible && source .env.news-app && ansible-playbook -i inventory/demo site.yml -t config