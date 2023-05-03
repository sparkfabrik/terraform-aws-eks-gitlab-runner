module "gitlab_runner" {
  source                    = "../"
  runner_registration_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  eks_cluster_name          = "test-eks-cluster"
}
