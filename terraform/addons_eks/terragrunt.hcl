include "global_config" {
  path = find_in_parent_folders("terragrunt-global-config.hcl")
}

dependency "terraform_eks" {
  config_path  = "/Users/saifeddine.rajhi/personal/velero-eks-backup/aws-eks-irsa/terraform/terraform_eks"

}
inputs = {

  eks_cluster_id       = dependency.terraform_eks.outputs.eks_cluster_id
  eks_cluster_endpoint = dependency.terraform_eks.outputs.eks_cluster_endpoint
  eks_oidc_provider    = dependency.terraform_eks.outputs.eks_oidc_issuer_url
  eks_cluster_version  = dependency.terraform_eks.outputs.eks_cluster_version
  oidc_provider_arn  = dependency.terraform_eks.outputs.oidc_provider_arn
  eks_oidc_issuer_url = dependency.terraform_eks.outputs.eks_oidc_issuer_url
  oidc_provider_url_without_http_prefix = dependency.terraform_eks.outputs.oidc_provider_url_without_http_prefix
  eks_cluster_certificate_authority_data = dependency.terraform_eks.outputs.eks_cluster_certificate_authority_data

}