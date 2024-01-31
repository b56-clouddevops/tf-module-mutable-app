# Creates Spot Instances
resource "aws_spot_instance_request" "spot" {
  count                      = var.SPOT_INSTANCE_COUNT
  ami                        = data.aws_ami.image.id
  instance_type              = var.SPOT_INSTANCE_TYPE
  vpc_security_group_ids     = [aws_security_group.allows_app.id]
  wait_for_fulfillment       = true
  iam_instance_profile       = "b56-admin"
 
  subnet_id                  = var.INTERNAL ? element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS, count.index) : element(data.terraform_remote_state.vpc.outputs.PUBLIC_SUBNET_IDS, count.index)

}

# Creates OD Instances
resource "aws_instance" "od" {
  count                      = var.OD_INSTANCE_COUNT

  ami                        = data.aws_ami.image.id                
  instance_type              = var.OD_INSTANCE_TYPE
  vpc_security_group_ids     = [aws_security_group.allows_app.id]
  subnet_id                  = var.INTERNAL ? element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS, count.index) : element(data.terraform_remote_state.vpc.outputs.PUBLIC_SUBNET_IDS, count.index)
  iam_instance_profile       = "b56-admin"
}


# Creating EC2 Tags
resource "aws_ec2_tag" "app_tags" {
  count                     = local.INSTANCE_COUNT

  resource_id               = element(local.INSTANCE_IDS, count.index)
  key                       = "Name"
  value                     = "${var.COMPONENT}-${var.ENV}"
}


# Prometheus Monitoring Tags
resource "aws_ec2_tag" "prometheus_tags" {
  count                     = local.INSTANCE_COUNT

  resource_id               = element(local.INSTANCE_IDS, count.index)
  key                       = "Monitor"
  value                     = "yes"
}

