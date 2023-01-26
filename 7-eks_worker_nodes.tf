resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = aws_eks_cluster.martorano-eks.name
  version         = var.cluster_version
  node_group_name = "martorano-private-nodes"
  node_role_arn   = aws_iam_role.workernodes.arn
  subnet_ids = [
    element(module.vpc.private_subnets, 0),
    element(module.vpc.private_subnets, 1),
    element(module.vpc.private_subnets, 2),
  ]
  instance_types = ["t3.small"]
  capacity_type  = "ON_DEMAND"

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
  # Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
