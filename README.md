# terraform-aws-eks-gitlab-runner
<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.63 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.9 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.19 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.5 |
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.63 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.9 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.19 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.5 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_external_runner_user"></a> [add\_external\_runner\_user](#input\_add\_external\_runner\_user) | Set to true to create an iam-user with scoped access to AWS services | `bool` | `false` | no |
| <a name="input_aws_tags"></a> [aws\_tags](#input\_aws\_tags) | Optional additional AWS tags | `map(string)` | `{}` | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | The name of the cluster where we install resources, it's used to retrieve cluster values used in the module. | `string` | n/a | yes |
| <a name="input_eks_cluster_oidc_issuer_url"></a> [eks\_cluster\_oidc\_issuer\_url](#input\_eks\_cluster\_oidc\_issuer\_url) | The OIDC issuer URL of the cluster. | `string` | n/a | yes |
| <a name="input_external_runner_user_name"></a> [external\_runner\_user\_name](#input\_external\_runner\_user\_name) | The name of the iam-user to be created. | `string` | `"external-runner-user"` | no |
| <a name="input_external_runner_user_policies"></a> [external\_runner\_user\_policies](#input\_external\_runner\_user\_policies) | The list of policies to be attached to the iam-user. | `list(string)` | <pre>[<br>  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"<br>]</pre> | no |
| <a name="input_minio_bucket_name"></a> [minio\_bucket\_name](#input\_minio\_bucket\_name) | The name of the minio bucket used to store the cache. | `string` | `"runner"` | no |
| <a name="input_minio_chart"></a> [minio\_chart](#input\_minio\_chart) | The chart name. Be sure to use the version corresponding to your Gitlab version. | `string` | `"minio"` | no |
| <a name="input_minio_chart_version"></a> [minio\_chart\_version](#input\_minio\_chart\_version) | The chart version. Be sure to use the version corresponding to your Gitlab version. | `string` | `"8.0.10"` | no |
| <a name="input_minio_node_affinity"></a> [minio\_node\_affinity](#input\_minio\_node\_affinity) | The node affinity for the minio pod. | `string` | `""` | no |
| <a name="input_minio_persistence_size"></a> [minio\_persistence\_size](#input\_minio\_persistence\_size) | The size of the minio bucket used to store the cache. | `string` | `"50Gi"` | no |
| <a name="input_minio_persistence_storage_class_name"></a> [minio\_persistence\_storage\_class\_name](#input\_minio\_persistence\_storage\_class\_name) | The storage class name for the minio bucket used to store the cache. | `string` | `""` | no |
| <a name="input_minio_release_name"></a> [minio\_release\_name](#input\_minio\_release\_name) | The release name. Be sure to use the version corresponding to your Gitlab version. | `string` | `"minio-chart"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Gitlab runner namespace name. | `string` | `"gitlab-runner"` | no |
| <a name="input_runner_additional_policy_arns"></a> [runner\_additional\_policy\_arns](#input\_runner\_additional\_policy\_arns) | The list of additional policies to be attached to the gitlab runner role. | `list(string)` | `[]` | no |
| <a name="input_runner_chart_version"></a> [runner\_chart\_version](#input\_runner\_chart\_version) | The chart version. Be sure to use the version corresponding to your Gitlab version. | `string` | `"0.52.0"` | no |
| <a name="input_runner_registration_token"></a> [runner\_registration\_token](#input\_runner\_registration\_token) | The gitlab runner registration token. You can retrieve it is from your Gitlab project or group backend in the CI/CD settings. | `string` | n/a | yes |
| <a name="input_runner_tags"></a> [runner\_tags](#input\_runner\_tags) | Specify the tags associated with the runner. Comma-separated list of tags. | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_api_url"></a> [cluster\_api\_url](#output\_cluster\_api\_url) | The EKS cluster API URL. |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | The EKS cluster certificate authority data. |
| <a name="output_cluster_information"></a> [cluster\_information](#output\_cluster\_information) | The EKS cluster information. |
| <a name="output_current_aws_caller_identity"></a> [current\_aws\_caller\_identity](#output\_current\_aws\_caller\_identity) | The current AWS caller identity. |
| <a name="output_gitlab_cluster_admin_service_token"></a> [gitlab\_cluster\_admin\_service\_token](#output\_gitlab\_cluster\_admin\_service\_token) | The service token scoped to kube-system with cluster-admin privileges. |
| <a name="output_gitlab_external_runner_user_access_key_id"></a> [gitlab\_external\_runner\_user\_access\_key\_id](#output\_gitlab\_external\_runner\_user\_access\_key\_id) | The access key for the external runner user. |
| <a name="output_gitlab_external_runner_user_secret_key_id"></a> [gitlab\_external\_runner\_user\_secret\_key\_id](#output\_gitlab\_external\_runner\_user\_secret\_key\_id) | The secret key for the external runner user. |
| <a name="output_minio_accesskey"></a> [minio\_accesskey](#output\_minio\_accesskey) | The access key for the Minio bucket. |
| <a name="output_minio_secretkey"></a> [minio\_secretkey](#output\_minio\_secretkey) | The secret key for the Minio bucket. |
## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.external_runner_user_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.external_runner_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.external_runner_user_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [helm_release.gitlab_runner](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.minio](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_cluster_role_binding.gitlab_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding) | resource |
| [kubernetes_namespace.gitlab_runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret_v1.gitlab_admin_token](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.gitlab_runner_worker_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_service_account_v1.gitlab](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |
| [kubernetes_service_account_v1.gitlab_runner_worker_sa](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |
| [random_password.minio_accesskey](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.minio_secretkey](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_eks_cluster.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_with_oidc_for_gitlab_runner"></a> [iam\_assumable\_role\_with\_oidc\_for\_gitlab\_runner](#module\_iam\_assumable\_role\_with\_oidc\_for\_gitlab\_runner) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | ~> 5.17 |

<!-- END_TF_DOCS -->