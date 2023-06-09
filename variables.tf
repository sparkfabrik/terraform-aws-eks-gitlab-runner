variable "namespace" {
  type        = string
  description = "Gitlab runner namespace name."
  default     = "gitlab-runner"
}

variable "runner_chart_version" {
  type        = string
  description = "The chart version. Be sure to use the version corresponding to your Gitlab version."
  default     = "0.52.0"
}

variable "runner_registration_token" {
  type        = string
  description = "The gitlab runner registration token. You can retrieve it is from your Gitlab project or group backend in the CI/CD settings."
}

variable "eks_cluster_oidc_issuer_url" {
  type        = string
  description = "The OIDC issuer URL of the cluster."
}

variable "aws_tags" {
  type        = map(string)
  description = "Optional additional AWS tags"
  default     = {}
}

# refs: https://docs.gitlab.com/ce/ci/runners#use-tags-to-limit-the-number-of-jobs-using-the-runner
variable "runner_tags" {
  type        = string
  description = "Specify the tags associated with the runner. Comma-separated list of tags."
}

variable "runner_additional_policy_arns" {
  type        = list(string)
  description = "The list of additional policies to be attached to the gitlab runner role."
  default     = []
}

variable "minio_bucket_name" {
  type        = string
  description = "The name of the minio bucket used to store the cache."
  default     = "runner"
}

variable "minio_persistence_size" {
  type        = string
  description = "The size of the minio bucket used to store the cache."
  default     = "50Gi"
}

variable "minio_node_affinity" {
  type        = string
  description = "The node affinity for the minio pod."
  default     = ""
}

variable "minio_chart_version" {
  type        = string
  description = "The chart version. Be sure to use the version corresponding to your Gitlab version."
  default     = "8.0.10"
}

variable "minio_chart" {
  type        = string
  description = "The chart name. Be sure to use the version corresponding to your Gitlab version."
  default     = "minio"
}

variable "minio_release_name" {
  type        = string
  description = "The release name. Be sure to use the version corresponding to your Gitlab version."
  default     = "minio-chart"
}

variable "minio_persistence_storage_class_name" {
  type        = string
  description = "The storage class name for the minio bucket used to store the cache."
  default     = ""
}
