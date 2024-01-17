# In your case, pleaes use the Lab Image : "DevOps-LabImage-Centos7" and install Ansible On it and take an AMI with the name of your choice "image-ansible-xxxx" and then use it
# Ensure the AMI that you use has ANSIBLE Installed.
data "aws_ami" "image" {
  most_recent      = true
  name_regex       = "centos7-with-ansible"
  owners           = ["355449129696"]              # Use your account number
}

# Datasource to fetch the information from the VPC Remote Statefile
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "b56-terraform-state-bucket"
    key     = "vpc/${var.ENV}/terraform.tfstate"
    region  = "us-east-1"
  }
}