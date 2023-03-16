provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.martorano-eks.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.martorano-eks.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.token.token
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.martorano-eks.id]
      command     = "aws"
    }
  }
}

resource "aws_iam_policy" "albc" {
  name_prefix = "AWSLoadBalancerControllerIAMPolicy"
  description = "Allows lb controller ${local.cluster_name} to manage ALB and NLB"
  policy      = data.http.albc_policy_json.response_body
}
resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.4.1"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.martorano-eks.id
  }

  set {
    name  = "image.tag"
    value = "v2.4.2"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_load_balancer_controller.arn
  }

  depends_on = [
    aws_eks_node_group.worker-node-group,
    aws_iam_role_policy_attachment.aws_load_balancer_controller_attach
  ]
}

module "albc_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "3.5.0"

  create_role                   = true
  role_name                     = "irsa-aws-load-balancer-controller"
  role_policy_arns              = [aws_iam_policy.albc.arn]
  provider_url                  = aws_iam_openid_connect_provider.eks.url
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
}
