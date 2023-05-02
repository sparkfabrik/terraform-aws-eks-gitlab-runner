output "cluster_information" {
  description = "The EKS cluster information."
  value       = data.aws_eks_cluster.current
}

output "current_aws_caller_identity" {
  description = "The current AWS caller identity."
  value       = data.aws_caller_identity.current
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = try(data.aws_eks_cluster.this[0].identity[0].oidc[0].issuer, null)
}

output "cluster_api_url" {
  description = "The EKS cluster API URL."
  value       = data.aws_eks_cluster.current.endpoint
}

output "cluster_certificate_authority_data" {
  sensitive   = true
  description = "The EKS cluster certificate authority data."
  value       = trimspace(base64decode(data.aws_eks_cluster.current.certificate_authority[0].data))
}

output "minio_accesskey" {
  sensitive   = true
  description = "The access key for the Minio bucket."
  value       = random_password.minio_accesskey.result
}

output "minio_secretkey" {
  sensitive   = true
  description = "The secret key for the Minio bucket."
  value       = random_password.minio_secretkey.result
}

output "gitlab_cluster_admin_service_token" {
  sensitive   = true
  description = "The service token scoped to kube-system with cluster-admin privileges."
  value       = kubernetes_secret_v1.gitlab_admin_token.data["token"]
}

output "gitlab_external_runner_user_access_key_id" {
  sensitive   = true
  description = "The access key for the external runner user."
  value       = var.add_external_runner_user ? aws_iam_access_key.external_runner_user_key[0].id : "not available"
}

output "gitlab_external_runner_user_secret_key_id" {
  sensitive   = true
  description = "The secret key for the external runner user."
  value       = var.add_external_runner_user ? aws_iam_access_key.external_runner_user_key[0].secret : "not available"
}
