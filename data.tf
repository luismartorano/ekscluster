# AWS Load Balancer Controller
data "http" "albc_policy_json" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.3/docs/install/iam_policy.json"
}

# AWS Secrets and Configuration Provider
data "http" "ascp_csi_driver" {
  url = "https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml"
}


