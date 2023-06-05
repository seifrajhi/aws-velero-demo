data "aws_iam_policy_document" "aws_cli_describe_ec2_instances_assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type = "Federated"
      identifiers = [
        var.oidc_provider_arn
      ]
    }
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url_without_http_prefix}:aud"
      values   = ["sts.amazonaws.com"]
    }
      condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url_without_http_prefix}:sub"
      values   = ["system:serviceaccount:${local.namespace}:velero-server"]
    }
  }
}

resource "aws_iam_role" "this" {
  name                 = "aws-cli-describe-ec2-instances"
  path                 = "/"
  description          = "RSA Role for AWS CLI pods"
  max_session_duration = 43200
  assume_role_policy   = data.aws_iam_policy_document.aws_cli_describe_ec2_instances_assume_policy.json
}

data "aws_iam_policy_document" "describe_ec2_instances" {
  statement {
    sid    = "EC2DescribeInstances"
    effect = "Allow"
    actions = [
      "ec2:*",
      "s3:*",

    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "describe_ec2_instances" {
  name        = "irsa-describe-ec2-instances"
  description = "Allow ${var.project} AWS CLI pods to describe EC2 instances"
  policy      = data.aws_iam_policy_document.describe_ec2_instances.json
}

resource "aws_iam_role_policy_attachment" "describe_ec2_instances" {
  policy_arn = aws_iam_policy.describe_ec2_instances.arn
  role       = aws_iam_role.this.name
}
