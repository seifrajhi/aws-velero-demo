locals {
    tags = {
    author  = "saif"
    project = var.project
  }
  namespace_name = coalesce(var.namespace_name, var.name)
  namespace      = data.kubernetes_namespace.this.metadata[0].name

  additional_value = tolist([
    templatefile("${path.module}/templates/serviceaccount.template.yaml", {
      EKS_ROLE_ARN = aws_iam_role.this.arn
    }),
  ])  
}