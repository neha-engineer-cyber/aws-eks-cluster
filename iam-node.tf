resource "aws_iam_role" "node_role" {
  name = "node_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole"
        ]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "node_policy" {
  statement {
    sid = "NodeAccess"

    actions = [
      "ecr:*",
      "iam:CreateServiceLinkedRole"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "node_policy" {
  name   = "node_policy"
  policy = data.aws_iam_policy_document.node_policy.json
}

resource "aws_iam_role_policy_attachment" "attach1" {
  policy_arn = aws_iam_policy.node_policy.arn
  role = aws_iam_role.node_role.arn
}

resource "aws_iam_role_policy_attachment" "attach2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.node_role.arn
}


resource "aws_iam_role_policy_attachment" "attach3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role = aws_iam_role.node_role.arn
}

resource "aws_iam_role_policy_attachment" "attach4" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.node_role.arn
}