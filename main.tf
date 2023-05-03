locals {
  kubernetes_service_account_secret_name_runner_worker      = "gitlab-runner-worker"
  kubernetes_service_account_secret_name_gitlab_admin_token = "gitlab"
}

// -----------------------
// Create the namespace.
// -----------------------
resource "kubernetes_namespace" "gitlab_runner" {
  metadata {
    labels = {
      name = var.namespace
    }
    name = var.namespace
  }
}

// -----------------------
// Minio bucket credentials
// -----------------------
resource "random_password" "minio_accesskey" {
  length           = 20
  special          = true
  override_special = "_%@"
}

resource "random_password" "minio_secretkey" {
  length           = 40
  special          = true
  override_special = "_%@"
}

// -----------------------
// Gitlab Runner IAM and Service Account
// -----------------------
// Creating an IAM role and policy for Gitlab Runner Kubernetes Service Account.
// refs: https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
module "iam_assumable_role_with_oidc_for_gitlab_runner" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 5.17"

  create_role = true
  role_name   = "gitlab-runner-oidc"

  tags         = var.aws_tags
  provider_url = var.eks_cluster_oidc_issuer_url

  role_policy_arns = concat(
    [
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
    ],
    var.runner_additional_policy_arns
  )

  number_of_role_policy_arns = 1
}

// Create the Kubernetes Service Account for gitlab-runner
resource "kubernetes_secret_v1" "gitlab_runner_worker_secret" {
  metadata {
    name      = local.kubernetes_service_account_secret_name_runner_worker
    namespace = var.namespace
    # https://docs.aws.amazon.com/eks/latest/userguide/specify-service-account-role.html
    # eks.amazonaws.com/role-arn=arn:aws:iam::<ACCOUNT_ID>:role/<IAM_ROLE_NAME>
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.gitlab_runner_worker_sa.metadata[0].name
      "eks.amazonaws.com/role-arn"         = module.iam_assumable_role_with_oidc_for_gitlab_runner.iam_role_arn
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_service_account_v1" "gitlab_runner_worker_sa" {
  metadata {
    name      = local.kubernetes_service_account_secret_name_runner_worker
    namespace = var.namespace
  }
  secret {
    name = local.kubernetes_service_account_secret_name_runner_worker
  }

  depends_on = [
    kubernetes_namespace.gitlab_runner,
  ]
}

// -----------------------
// Gitlab Runner
// -----------------------
// Gitlab runner Helm chart values.

// refs: https://gitlab.com/gitlab-org/charts/gitlab-runner
resource "helm_release" "gitlab_runner" {
  # Helm release name is build as [name]-[chart].
  name             = "gitlab"
  repository       = "https://charts.gitlab.io"
  chart            = "gitlab-runner"
  namespace        = var.namespace
  version          = var.runner_chart_version
  create_namespace = false

  values = [
    templatefile("${path.module}/files/values.gitlab-runner.yml", {
      minio_server              = helm_release.minio.name
      bucket_name               = var.minio_bucket_name
      runner_registration_token = var.runner_registration_token
      cache_secretname          = random_password.minio_secretkey.result
      minio_access_key          = random_password.minio_accesskey.result
      minio_secret_key          = random_password.minio_secretkey.result
      runner_tags               = var.runner_tags
      runner_sa_name            = kubernetes_service_account_v1.gitlab_runner_worker_sa.metadata[0].name
    })
  ]
}

// -----------------------
// S3 Minio (used for Runners cache layer)
// -----------------------
// Minio Helm chart values.
resource "helm_release" "minio" {
  name             = var.minio_release_name
  repository       = "https://helm.min.io/"
  chart            = var.minio_chart
  namespace        = var.namespace
  version          = var.minio_chart_version
  create_namespace = false
  values = [
    templatefile("${path.module}/files/values.minio.yaml", {
      minio_persistence_size               = var.minio_persistence_size
      minio_node_affinity                  = var.minio_node_affinity
      minio_access_key                     = random_password.minio_accesskey.result
      minio_secret_key                     = random_password.minio_secretkey.result
      bucket_name                          = var.minio_bucket_name
      minio_persistence_storage_class_name = var.minio_persistence_storage_class_name
    })
  ]
}

// -----------------------
// GitLab cluster integration
// -----------------------
// Here we create the SA for gitlab needed for cluster integration in Gitlab.
// Docs: https://docs.gitlab.com/ee/user/project/clusters/add_existing_cluster.html
# Add the service account token used in the kubeconfig.
resource "kubernetes_secret_v1" "gitlab_admin_token" {
  metadata {
    name      = local.kubernetes_service_account_secret_name_gitlab_admin_token
    namespace = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.gitlab.metadata[0].name
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_service_account_v1" "gitlab" {
  metadata {
    name      = local.kubernetes_service_account_secret_name_gitlab_admin_token
    namespace = "kube-system"
  }
  secret {
    name = local.kubernetes_service_account_secret_name_gitlab_admin_token
  }

  depends_on = [
    kubernetes_namespace.gitlab_runner,
  ]
}

// Assign the cluster-admin role to both gitlab and gitlab-runner-runner-worker
// service account.
resource "kubernetes_cluster_role_binding" "gitlab_admin" {
  metadata {
    name = "gitlab-admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.gitlab.metadata[0].name
    namespace = kubernetes_service_account_v1.gitlab.metadata[0].namespace
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.gitlab_runner_worker_sa.metadata[0].name
    namespace = var.namespace
  }
}
