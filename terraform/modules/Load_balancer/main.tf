resource "aws_lb" "lb" {
  name            = var.lb_name
  subnets         =  var.public_subnet_ids
  security_groups = var.lb_sg
}

resource "aws_lb_target_group" "tg" {
  name        = var.target_group_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/" 
    interval            = 100       
    timeout             = 90        
    healthy_threshold   = 2         
    unhealthy_threshold = 10        
    matcher             = "200-399" 
  }

}

data "aws_acm_certificate" "domain" {
  domain = var.domain 
  most_recent = true           
  statuses = ["ISSUED"]        
}


resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.lb.id
  port              = "443"
  protocol          = "HTTPS"

  certificate_arn = data.aws_acm_certificate.domain.arn


  default_action {
    target_group_arn = aws_lb_target_group.tg.id
    type             = "forward"
  }
}