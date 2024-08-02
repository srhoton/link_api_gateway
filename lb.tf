resource "aws_lb" "dev_lb" {
  name = "dev-lb"
  internal = true
  load_balancer_type = "application"
  subnets =  [data.aws_subnet.private_1.id, data.aws_subnet.private_2.id, data.aws_subnet.private_3.id]

  tags = {
    Name = "dev-lb"
    }
}

resource "aws_lb_target_group" "dev_tg" {
  name = "dev-tg"
  port = 443
  protocol = "HTTPS"
  vpc_id = data.aws_vpc.dev_vpc.id
  target_type = "ip"
}


resource "aws_lb_listener" "dev_listener" {
  load_balancer_arn = aws_lb.dev_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.amazon_issued.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev_tg.arn
  }
}
