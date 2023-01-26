resource "aws_eks_cluster" "martorano-eks" {
  name     = local.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks-iam-role.arn

  vpc_config {
    subnet_ids = [
      "${element(module.vpc.private_subnets, 0)}",
      "${element(module.vpc.private_subnets, 1)}",
      "${element(module.vpc.private_subnets, 2)}",
      "${element(module.vpc.public_subnets, 0)}",
      "${element(module.vpc.public_subnets, 1)}",
      "${element(module.vpc.public_subnets, 2)}",

    ]
  }

  depends_on = [
    aws_iam_role.eks-iam-role,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly
  ]
}
