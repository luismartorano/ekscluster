resource "aws_eks_node_group" "worker-node-group" {
  cluster_name    = aws_eks_cluster.martorano-eks.name
  node_group_name = "martorano-workernodes"
  node_role_arn   = aws_iam_role.workernodes.arn
  subnet_ids      = local.subnets
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
