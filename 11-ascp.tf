resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "aws eks --region ${local.region} update-kubeconfig --name ${local.cluster_name} --profile ${local.profile}"
  }
}
resource "helm_release" "csi_secrets_store" {
  depends_on = [aws_eks_cluster.martorano-eks]
  name       = "csi-secrets-store"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"

  values = [yamlencode(
    {
      clusterName          = local.cluster_name
      enableSecretRotation = true
      syncSecret = {
        enabled = true
      }
    }
  )]
}

resource "kubectl_manifest" "ascp_csi_driver" {
  depends_on = [helm_release.csi_secrets_store]
  yaml_body  = data.http.ascp_csi_driver.response_body
}
