data "aws_availability_zones" "all" {}

# Creating Security Group for EC2 #
resource "aws_security_group" "instance" {
  name   = "govtech-assignment-instance"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating Launch Configuration #
resource "aws_launch_configuration" "govtech-assignment" {
  name            = "govtech-app-launch-configuration"
  image_id        = lookup(var.amis, var.region)
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]
  associate_public_ip_address = true
  key_name        = var.key_name
  user_data       = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y npm
              sudo apt install git
              sudo git clone https://github.com/ruwindada/interview-govtech-assignment-repo
              cd /interview-govtech-assignment-repo/helloworldapp
              nohup sudo npm start &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

# Creating AutoScaling Group #
resource "aws_autoscaling_group" "govtech-assignment" {
  name                 = "govtech-app-autoscaling-group"
  launch_configuration = aws_launch_configuration.govtech-assignment.id
  vpc_zone_identifier  = var.vpc_zone_identifier
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size

  tag {
    key                 = "Name"
    value               = "govtech-assignment"
    propagate_at_launch = true
  }
}

# Creating autoscaling policy
resource "aws_autoscaling_policy" "govtech-assignment" {
  name                   = "govtech-assignment-autoscaling_policy"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.govtech-assignment.name
}

# Creating cloudwatch metric alarm
resource "aws_cloudwatch_metric_alarm" "govtech-assignment" {
  alarm_name          = "govtech-assignment-autoscaling-util-alert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.govtech-assignment.name
  }

  alarm_description = "This metric monitors govtech-assignment cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.govtech-assignment.arn]
}

# Security Group for ALB #
  resource "aws_security_group" "alb-sg" {
  name   = "govtech-assignment-alb-sg"
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating LB #
resource "aws_lb" "alb" {
  name            = "govtech-assignment-alb"
  subnets         = var.vpc_zone_identifier
  security_groups = ["${aws_security_group.alb-sg.id}"]
  internal           = false
  load_balancer_type = "application"
}

# ALB target group creation #
resource "aws_lb_target_group" "alb-tg" {
  name     = "govtech-assignment-alb-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# ALB Listner #
  resource "aws_lb_listener" "alb_listner" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
  type             = "forward"
  target_group_arn = aws_lb_target_group.alb-tg.arn
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "govtech-assignment" {
  autoscaling_group_name = aws_autoscaling_group.govtech-assignment.id
  lb_target_group_arn    = aws_lb_target_group.alb-tg.arn
}
