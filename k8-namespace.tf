resource "kubernetes_namespace_v1" "example" {
  
  metadata {
    name = local.namespace
  }
  depends_on = [ aws_eks_cluster.cluster,aws_autoscaling_group.worker_asg ]
}