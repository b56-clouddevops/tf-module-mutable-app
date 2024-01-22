# Creates Target Group
resource "aws_lb_target_group" "app" {
  name        = "${var.COMPONENT}-${var.ENV}-tg"
  port        = var.APP_PORT
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID

  health_check {
    enabled             = true 
    healthy_threshold   = 2 
    interval            = 5 
    timeout             = 4
    path                = "/health"
    unhealthy_threshold = 2
  }
}

# Attches the instances to the target group
resource "aws_lb_target_group_attachment" "attach_instances" {
  count            = local.INSTANCE_COUNT

  target_group_arn = aws_lb_target_group.app.arn
  target_id        = element(local.INSTANCE_IDS, count.index)
  port             = var.APP_PORT
}