provider "aws" {
region = "us-east-1"
}
resource "aws_launch_configuration" "Hitachi-PROD" {
  #name_prefix = "Hitachi-PROD"
   name = "Hitachi-PRODLC"
  image_id = "ami-06640050dc3f556bb" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.small"
  iam_instance_profile = "ssm"
  key_name = "coalindia1"
  #security_groups = ["sg-0f26eebf1b3476c10"]
  security_groups = [aws_security_group.Hitachi-PROD.id]
    root_block_device {
    #device_name = "/dev/xvdb"
    volume_type = "gp3"
    volume_size = 10
	encrypted   = true
	#kms_key_id  =  "arn:aws:kms:ap-south-1:371348661740:key/918670b8-f7a8-4c71-8ac2-d946da0de843"
	delete_on_termination = true
  }
   user_data = "${file("hitachi.sh")}"
}
resource "aws_autoscaling_group" "Hitachi-PROD" {
  name = "Hitachi-PROD-ASG"
  min_size             = 1
  desired_capacity     = 1
  max_size             = 2

  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.Hitachi-PROD.name
  # target_group_arns = [aws_lb_target_group.Hitachi-PROD-tg.arn]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

#  vpc_zone_identifier  = [
 #   "subnet-067580808793a509b",
  #  "subnet-07fa40ac193ba9b05",
  #  "subnet-097d414e4bf4e51e4"
  #]
  vpc_zone_identifier = ["${aws_subnet.cidr_private_subnet_a.id}"]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }
tags = [
  {
    "key" = "Name"
    "value" = "Hitachi-PROD"
    "propagate_at_launch" = true
  },
  {
    "key" = "Environment"
    "value" = "PROD"
    "propagate_at_launch" = true
	},
	{
    "key" = "Application Name"
    "value" = "Webserver"
    "propagate_at_launch" = true
	},
	{
    "key" = "Cost Center"
    "value" = "Production"
    "propagate_at_launch" = true
	},
	{
    "key" = "Backup Retention"
    "value" = "yes"
    "propagate_at_launch" = true
	},
	{
    "key" = "Partner Name"
    "value" = "ACC"
    "propagate_at_launch" = true
	},
	{
    "key" = "Department"
    "value" = "Infra"
    "propagate_at_launch" = true
	},
    ]

}

resource "aws_autoscaling_policy" "Hitachi-PROD-UAT_Memory_Scale_UP" {
  name = "Hitachi-PROD-UAT_Memory_Scale_UP"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.Hitachi-PROD.name
}

resource "aws_cloudwatch_metric_alarm" "Hitachi-PROD-UAT_Memory_alarm_Scale_UP" {
  alarm_name = "Hitachi-PROD-UAT_Memory_alarm_Scale_UP"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "MemoryUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.Hitachi-PROD.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.Hitachi-PROD-UAT_Memory_Scale_UP.arn ]
}



resource "aws_autoscaling_policy" "Hitachi-PROD-UAT_CPU_Scale_UP" {
  name = "Hitachi-PROD-UAT_CPU_Scale_UP"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.Hitachi-PROD.name
}

resource "aws_cloudwatch_metric_alarm" "Hitachi-PROD-UAT_CPU_alarm_Scale_UP" {
  alarm_name = "Hitachi-PROD-UAT_CPU_alarm_Scale_UP"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.Hitachi-PROD.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.Hitachi-PROD-UAT_CPU_Scale_UP.arn ]
}

resource "aws_autoscaling_policy" "Hitachi-PROD-UAT_CPU_Scale_DOWN" {
  name = "Hitachi-PROD-UAT_CPU_Scale_DOWN"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.Hitachi-PROD.name
}

resource "aws_cloudwatch_metric_alarm" "Hitachi-PROD-UAT_CPU_alarm_Scale_DOWN" {
  alarm_name = "Hitachi-PROD-UAT_CPU_alarm_Scale_DOWN"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "30"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.Hitachi-PROD.name
  }

  alarm_description = "This metric monitor EC2 instance CPU utilization"
  alarm_actions = [ aws_autoscaling_policy.Hitachi-PROD-UAT_CPU_Scale_DOWN.arn ]
}


resource "aws_autoscaling_policy" "Hitachi-PROD-UAT_Memory_Scale_DOWN" {
  name = "Hitachi-PROD-UAT_Memory_Scale_DOWN"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.Hitachi-PROD.name
}

resource "aws_cloudwatch_metric_alarm" "Hitachi-PROD-UAT_Memory_alarm_Scale_DOWN" {
  alarm_name = "Hitachi-PROD-UAT_Memory_alarm_Scale_DOWN"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "MemoryUtilization"
  namespace = "AWS/EC2"
  period = "120"
  statistic = "Average"
  threshold = "30"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.Hitachi-PROD.name
  }

  alarm_description = "This metric monitor EC2 instance Memory utilization"
  alarm_actions = [ aws_autoscaling_policy.Hitachi-PROD-UAT_Memory_Scale_DOWN.arn ]
}

resource "aws_lb_target_group" "Hitachi-PROD-TG" {
  name     = "Hitachi-PROD-TG"
  port     = 8080
 protocol = "HTTP"
  vpc_id   = "${aws_vpc.hitachi_vpc.id}"
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb" "lb_hitachi" {
  name               = "hitachi-elb"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["${aws_subnet.cidr_public_subnet_a.id}", "${aws_subnet.cidr_public_subnet_b.id}"]
  security_groups    = ["${aws_security_group.Hitachi-PROD.id}"]
  enable_deletion_protection = false
  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_lb_listener" "IB-API" {
  #listener_arn = "arn:aws:elasticloadbalancing:ap-south-1:476827303802:listener/app/IM-VER-PROD-LB/2687b802eb738bb3/0ce6499695b0b72c"
  #priority     = 15
  load_balancer_arn = "${aws_lb.lb_hitachi.arn}"
  port = "80"
  protocol = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Hitachi-PROD-TG.arn
  }

}
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
 autoscaling_group_name = aws_autoscaling_group.Hitachi-PROD.id
 alb_target_group_arn = aws_lb_target_group.Hitachi-PROD-TG.arn
}
