resource "null_resource" "wait" {
  provisioner "local-exec" {
   # command = "sleep 30"
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory1 ../ansible/ssh-known-hosts.yml"
  #   command = <<EOT
  #     sleep 130;
  #     ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory ../ansible/check-hosts.yml
  #  EOT
  }

  depends_on = [
    local_file.inventory
  ]
}

resource "null_resource" "cluster" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory ../ansible/swarm-deploy-cluster.yml"
  }

  depends_on = [
    null_resource.wait
  ]
}

resource "null_resource" "sync" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory ../ansible/swarm-deploy-sync.yml"
  }

  depends_on = [
    null_resource.cluster
  ]
}

resource "null_resource" "monitoring" {
  provisioner "local-exec" {
    command = "ANSIBLE_FORCE_COLOR=1 ansible-playbook -i ../ansible/inventory ../ansible/swarm-deploy-stack.yml --limit=managers"
  }

  depends_on = [
    null_resource.sync
  ]
}
