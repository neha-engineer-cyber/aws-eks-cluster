resource "aws_autoscaling_group" "worker_asg" {
  name = "worker_asg"
  min_size = 2
  max_size = 2
  health_check_grace_period = 30
  health_check_type = "EC2"
  vpc_zone_identifier = data.aws_subnets.subnet_ids.ids
  launch_template {
    id = aws_launch_template.node_template.id
    version = "$Latest"
  }
}