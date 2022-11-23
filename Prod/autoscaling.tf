provider "aws" {
region = "us-east-1"
}
resource "aws_launch_template" "Hitachi-PROD" {
  name_prefix = "Hitachi-Prod-LC"
  image_id = "ami-06640050dc3f556bb"
  iam_instance_profile {
    name = "ssm"
  }
  instance_type = "t3a.micro"
  key_name = "coalindia1"
  vpc_security_group_ids = [aws_security_group.Hitachi-PROD.id]
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 10
    }
  }
  user_data = filebase64("hitachi.sh")
}
resource "aws_autoscaling_group" "Hitachi-PROD" {
  name = "Hitachi-PROD-ASG"
  min_size             = 3
  desired_capacity     = 3
  max_size             = 4

  health_check_type    = "EC2"

 launch_template {
    id      = aws_launch_template.Hitachi-PROD.id
    version = aws_launch_template.Hitachi-PROD.latest_version
  }
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
  vpc_zone_identifier  = [
    "subnet-0386b39bb9417b6c5",
    "subnet-0acd23e31fb17a460"
  ]

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
  vpc_id   = "vpc-0a9f11ae4c267aa39"
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
  name               = "hitachi-elb-prod"
  internal           = false
  load_balancer_type = "application"
  subnets            = [
    "subnet-0386b39bb9417b6c5",
    "subnet-0acd23e31fb17a460"
  ]
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
