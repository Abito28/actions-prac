provider "aws" {
  region = "ap-northeast-1"
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
      values   = ["repo:Abito28/actions-prac:*"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name               = "github-actions-prac"
  assume_role_policy = data.aws_iam_policy_document.github_trust.json
}

output "role_arn" {
  value = aws_iam_role.github_actions.arn
}