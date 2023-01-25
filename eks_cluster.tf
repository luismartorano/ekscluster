resource "aws_eks_cluster" "martorano-eks" {
  name     = local.cluster_name
  role_arn = aws_iam_role.eks-iam-role.arn

  vpc_config {
    subnet_ids = local.subnets
  }

  depends_on = [
    aws_iam_role.eks-iam-role,
  ]
}
