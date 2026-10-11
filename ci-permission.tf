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
}

resource "aws_iam_role_policy" "plan_state_access" {
  name   = "plan-state-access"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.plan_state_access.json
}