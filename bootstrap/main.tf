locals {
  account_id    = "590183753633"
  repo_owner_id = "145816778"
  repo_id       = "1385934191"
  state_bucket  = "tf-state-590183753633"
}

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

data "aws_iam_policy_document" "github_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:YoungMaster009@${local.repo_owner_id}/terraform-aws-portfolio@${local.repo_id}:*",
      ]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "github-actions-terraform"
  assume_role_policy = data.aws_iam_policy_document.github_trust.json
}

data "aws_iam_policy_document" "github_actions" {
  statement {
    sid = "InfraServices"
    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "acm:*",
      "route53:*",
      "wafv2:*",
    ]
    resources = ["*"]
  }

  statement {
    sid       = "StateBucketList"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${local.state_bucket}"]
  }

  statement {
    sid     = "StateObjects"
    actions = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = [
      "arn:aws:s3:::${local.state_bucket}/dev/*",
      "arn:aws:s3:::${local.state_bucket}/prod/*",
    ]
  }

  statement {
    sid     = "AssetsBuckets"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::*-app1-assets-${local.account_id}",
      "arn:aws:s3:::*-app1-assets-${local.account_id}/*",
    ]
  }

  statement {
    sid     = "AppIam"
    actions = ["iam:*"]
    resources = [
      "arn:aws:iam::${local.account_id}:role/dev-*",
      "arn:aws:iam::${local.account_id}:role/prod-*",
      "arn:aws:iam::${local.account_id}:instance-profile/dev-*",
      "arn:aws:iam::${local.account_id}:instance-profile/prod-*",
      "arn:aws:iam::${local.account_id}:policy/dev-*",
      "arn:aws:iam::${local.account_id}:policy/prod-*",
    ]
  }

  statement {
    sid       = "ServiceLinkedRoles"
    actions   = ["iam:CreateServiceLinkedRole"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "github_actions" {
  name   = "terraform-portfolio-deploy"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.github_actions.json
}