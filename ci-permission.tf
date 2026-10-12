data "aws_iam_policy_document" "plan_state_access" {
  statement {
    sid       = "ListStateBucket"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.tfstate.arn]
  }

  statement {
    sid       = "ReadState"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.tfstate.arn}/actions-prac/terraform.tfstate"]
  }

  statement {
    sid       = "UseLockFile"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.tfstate.arn}/actions-prac/terraform.tfstate.tflock"]
  }

  statement {
    sid       = "ReadOidcProvider"
    actions   = ["iam:GetOpenIDConnectProvider"]
    resources = [aws_iam_openid_connect_provider.github.arn]
  }
  statement {
    sid = "ReadStateBucketSettings"
    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy",
      "s3:GetBucketVersioning",
      "s3:GetEncryptionConfiguration",
      "s3:GetBucketPublicAccessBlock",
      "s3:GetLifecycleConfiguration",
      "s3:GetBucketCORS",
      "s3:GetBucketWebsite",
      "s3:GetBucketLogging",
      "s3:GetAccelerateConfiguration",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketTagging",
      "s3:GetReplicationConfiguration",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketOwnershipControls",
    ]
    resources = [aws_s3_bucket.tfstate.arn]
  }

  statement {
    sid = "ReadCiRoles"
    actions = [
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
    ]
    resources = [
      aws_iam_role.plan.arn,
      aws_iam_role.apply.arn,
    ]
  }
}

resource "aws_iam_role_policy" "plan_state_access" {
  name   = "plan-state-access"
  role   = aws_iam_role.plan.id
  policy = data.aws_iam_policy_document.plan_state_access.json
}

data "aws_iam_policy_document" "apply_access" {
  source_policy_documents = [data.aws_iam_policy_document.plan_state_access.json]

  statement {
    sid       = "WriteState"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.tfstate.arn}/actions-prac/terraform.tfstate"]
  }
}

resource "aws_iam_role_policy" "apply_access" {
  name   = "apply-access"
  role   = aws_iam_role.apply.id
  policy = data.aws_iam_policy_document.apply_access.json
}