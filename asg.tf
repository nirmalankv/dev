resource "aws_launch_configuration" "demo_as-lc" {
  name = "${var.org}-${var.env}-ASLC-${var.version}"
  image_id      = "${data.aws_ami.image.id}" # us-west-2
  instance_type = "${var.instance_type}"
  key_name = "${var.keypair}"
  security_groups = ["${aws_security_group.my_sg.id}"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "demo_asg" {
  name                 = "${var.org}-${var.env}-ASG-${var.version}"
  launch_configuration = "${aws_launch_configuration.demo_as-lc.name}"
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  desired_capacity     = "${var.desired}"
  vpc_zone_identifier  = ["subnet-0d64e046", "subnet-d4fc66ad"]
  load_balancers= ["${aws_elb.demo_elb.id}"]
  health_check_type="ELB"
  lifecycle {
    create_before_destroy = true
  }
  tags{
    key                 = "Name"
    value               = "${var.org}-${var.env}-APP-${var.version}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "autopolicy-up" {
name = "terraform-autopolicy-up"
scaling_adjustment = 1
adjustment_type = "ChangeInCapacity"
cooldown = 300
autoscaling_group_name = "${aws_autoscaling_group.demo_asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarm-up" {
alarm_name = "terraform-alarm-up"
comparison_operator = "GreaterThanOrEqualToThreshold"
evaluation_periods = "2"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = "120"
statistic = "Average"
threshold = "60"

dimensions {
AutoScalingGroupName = "${aws_autoscaling_group.demo_asg.name}"
}

alarm_description = "This metric monitor EC2 instance cpu utilization"
alarm_actions = ["${aws_autoscaling_policy.autopolicy-up.arn}"]
}

resource "aws_autoscaling_policy" "autopolicy-down" {
name = "terraform-autopolicy-down"
scaling_adjustment = -1
adjustment_type = "ChangeInCapacity"
cooldown = 300
autoscaling_group_name = "${aws_autoscaling_group.demo_asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "cpualarm-down" {
alarm_name = "terraform-alarm-down"
comparison_operator = "LessThanOrEqualToThreshold"
evaluation_periods = "2"
metric_name = "CPUUtilization"
namespace = "AWS/EC2"
period = "120"
statistic = "Average"
threshold = "10"

dimensions {
AutoScalingGroupName = "${aws_autoscaling_group.demo_asg.name}"
}

alarm_description = "This metric monitor EC2 instance cpu utilization"
alarm_actions = ["${aws_autoscaling_policy.autopolicy-down.arn}"]
}

data "aws_ami" "image" {
  most_recent = true
  owners = ["self"]
  filter {
    name = "name"
    values = ["${var.org}_AMI-${var.env}"]
  }
}





