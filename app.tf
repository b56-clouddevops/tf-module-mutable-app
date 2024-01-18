resource "null_resource" "app_deploy" {
  count   = local.INSTANCE_COUNT

  provisioner "remote-exec" {

    # connection block establishes connection to this
    connection {
      type     = "ssh"
      user     = local.SSH_USERNAME
      password = local.SSH_PASSWORD
      host     = element(local.INSTANCE_IPS, count.index)             # aws_instance.sample.private_ip : Use this only if your provisioner is outside the resource.
    }

    inline = [
      "ansible-pull -U https://github.com/b56-clouddevops/ansible.git -e APP_VERSION=${var.APP_VERSION} -e ENV=${var.ENV} -e COMPONENT=${var.COMPONENT}  roboshop-pull.yml"
        ]
    }
}
