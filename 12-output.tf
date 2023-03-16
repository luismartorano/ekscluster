output "aws_load_balancer_controller_role_arn" {
  value = aws_iam_role.aws_load_balancer_controller.arn
}

output "externaldns_role_arn" {
  value = aws_iam_role.external_dns.arn
}



output "cluster_name" {
  description = "EKS cluster name."
  value       = local.cluster_name
}

output "cluster_ca_certificate" {
  description = "EKS control panel certificate in base64."
  value       = base64decode(aws_eks_cluster.martorano-eks.certificate_authority[0].data)
}
