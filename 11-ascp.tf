resource "helm_release" "csi_secrets_store" {
  depends_on = [module.eks-cluster]
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
