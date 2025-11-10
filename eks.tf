resource "aws_eks_cluster" "cluster" {
  name = local.cluster_name

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.31"

  vpc_config {
    subnet_ids = data.aws_subnets.subnet_ids.ids
    endpoint_private_access = true
    endpoint_public_access = true
  }
  

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy
  ]
}

resource "aws_eks_access_entry" "node_access_entry" {
  cluster_name      = aws_eks_cluster.cluster.name
  principal_arn     = aws_iam_role.node_role.arn
  kubernetes_groups = []
  type              = "EC2_LINUX"
}

resource "aws_eks_access_entry" "admin_access_entry" {
  cluster_name      = aws_eks_cluster.cluster.name
  principal_arn     = "arn:aws:iam::${local.account_id}:root"
  kubernetes_groups = []
  type              = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin_access_policy" {
  cluster_name  = aws_eks_cluster.cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::${local.account_id}:root"

  access_scope {
    type       = "cluster"
  }
}