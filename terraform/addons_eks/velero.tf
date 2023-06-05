resource "kubernetes_namespace" "this" {
    metadata {
    name = local.namespace_name
    annotations = {
      name = local.namespace_name
      "downscaler/exclude" = true
    }
    labels = {
      name        = local.namespace_name

    }
  }
}

# Retrieving this data will ensure that the target Kubernetes namespace exists
# before proceeding.
data "kubernetes_namespace" "this" {
  metadata {
    name = local.namespace_name
  }

  depends_on = [
    kubernetes_namespace.this,
  ]
}
resource "aws_s3_bucket" "backup_bucket" {
  bucket = var.bucket
  acl    = "private"

  tags = {
    Name = "eks-backup-velero-demo"
  }
}

resource "helm_release" "velero" {
  name       = "velero"
  repository = "https://vmware-tanzu.github.io/helm-charts"
  chart      = "velero"
  version    = "2.32.1"
  namespace  = "velero"

  values = [
   <<-EOT
    image:
      repository: velero/velero
      tag: v1.11.0
      pullPolicy: IfNotPresent
    resources:
      requests:
        cpu: 500m
        memory: 128Mi
      limits:
        cpu: 1000m
        memory: 512Mi
    dnsPolicy: ClusterFirst
    initContainers:
      - name: velero-plugin-for-aws
        image: velero/velero-plugin-for-aws:v1.5.1
        imagePullPolicy: IfNotPresent
        volumeMounts:
          - mountPath: /target
            name: plugins
    upgradeCRDs: true
    configuration:
      provider: aws
      backupStorageLocation:
          name: default
          provider: aws
          bucket: ${var.bucket}
          config:
            region: ${var.region}
      volumeSnapshotLocation:
          name: default
          bucket: ${var.bucket}
          provider: aws
          config:
            region: ${var.region}
 
    rbac:
      create: true
      clusterAdministrator: true
      clusterAdministratorName: cluster-admin
      credentials:
        useSecret: false
    serviceAccount:
      create: true
      server:
        annotations:
          eks.amazonaws.com/role-arn: arn:aws:iam::929724455131:role/aws-cli-describe-ec2-instances
    backupsEnabled: true
    snapshotsEnabled: true
  EOT
  ]
}





