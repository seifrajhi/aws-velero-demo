variable "aws_profile" {
  description = "Default AWS profile used as AWS credentials (passed in from terragrunt-global-config.hcl)"
  type        = string
}

variable "region" {
  default     = "eu-west-3"
  description = "AWS region"
  type        = string
}

variable "project" {
  default     = "aws-eks-irsa"
  description = "Name of the git project"
  type        = string
}

variable "oidc_provider_arn" {
  type        = string
  
}

variable "eks_cluster_id" {
    type        = string
}

variable "eks_cluster_endpoint" {
    type        = string
}
variable "eks_cluster_version" {
    type        = string
}
variable "eks_oidc_issuer_url" {
    type        = string
}

variable "oidc_provider_url_without_http_prefix" {
   type        = string
}

variable "eks_cluster_certificate_authority_data" {
  type = string
  
}
variable "name" {
  default     = "velero"
  description = "Installation name"
  type        = string
}

variable "namespace_name" {
  default     = "velero"
  description = "Kubernetes namespace name"
  type        = string
}

variable "bucket" {
  default = "eks-backup-velero-demo"
  description = "Backup and Restore bucket."
  type        = string
}