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
