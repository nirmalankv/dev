resource "aws_elb" "demo_elb" {
  name               = "${var.org}-${var.env}-ELB-${var.version}"
  availability_zones = ["us-west-2a", "us-west-2b"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${format("HA-ELB-%03d", count.index + 1)}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

output "elb-dns" {
value = "${aws_elb.demo_elb.dns_name}"
}
