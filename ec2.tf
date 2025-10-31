resource "aws_iam_instance_profile" "instance_profile" {
  name = "node_profile"
  role = aws_iam_role.node_role
}

resource "aws_launch_template" "node_template" {
  image_id = "ami-01029a233dce1c0e9"
  instance_type = "t2.medium"
  ebs_optimized = true
  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.instance_profile.name
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }
  user_data = base64encode(data.template_file.userdata.rendered)
  vpc_security_group_ids = [aws_security_group.worker_sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "WorkerNode"
      "kubernetes.io/cluster/${local.cluster_name}" = "owned"
    }
  }
}

data "template_file" "userdata"{
    template = file("${path.module}/userdata.sh")
    vars={

    }
}

