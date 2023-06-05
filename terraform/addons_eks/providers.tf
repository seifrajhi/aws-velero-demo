provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

data "aws_eks_cluster_auth" "eks_token" {
  name = var.eks_cluster_id
}

provider "kubernetes" {
  host                   = var.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(var.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks_token.token
}

provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(var.eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks_token.token
  }
}

provider "kubectl"{    

    
}