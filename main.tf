# Application Load Balancer
provider "aws" {
  region = "${var.region}"
}

resource "aws_alb" "toaiALB" {

name = "toaiALB"
    internal = false
    security_groups = ["${var.elb_sg}"]
    subnets = ["${var.sn1}","${var.sn2}","${var.sn3}"]
    idle_timeout = 60

tags {
        Name = "toaiALB"
    }

}

resource "aws_alb_listener" "alb-https" {
   load_balancer_arn = "${aws_alb.toaiALB.arn}"
   port = "443"
   protocol = "HTTPS"
   ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"
   certificate_arn = "${var.testSSL}"

default_action {
     target_group_arn = "${aws_alb_target_group.foo.arn}"
     type = "forward"
   }
}

resource "aws_alb_listener" "alb-http" {
   load_balancer_arn = "${aws_alb.toaiALB.arn}"
   port = "80"
   protocol = "HTTP"

default_action {
     target_group_arn = "${aws_alb_target_group.foo.arn}"
     type = "forward"
   }
}

resource "aws_alb_listener_rule" "bar-https" {
  listener_arn = "${aws_alb_listener.alb-https.arn}"
  priority = 1

action {
    type = "forward"
    target_group_arn = "${aws_alb_target_group.bar.arn}"
  }

condition {
    field = "path-pattern"
    values = ["/bar/"]
  }
}

resource "aws_alb_target_group" "foo" {
  name = "foo-alb-tg"
  port = 8080
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"
  deregistration_delay = 180
  stickiness {
     type = "lb_cookie"
     cookie_duration = 14400
     enabled = true
  }

health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      path = "/foo/health"
  }
}

resource "aws_alb_target_group" "bar" {
  name = "bar-alb-tg"
  port = 8080
  protocol = "HTTP"
  vpc_id = "${var.vpc_id}"
  deregistration_delay = 180
  stickiness {
     type = "lb_cookie"
     cookie_duration = 14400
     enabled = true
  }

health_check {
      healthy_threshold = 2
      unhealthy_threshold = 2
      timeout = 3
      path = "/bar/health"
  }
}
