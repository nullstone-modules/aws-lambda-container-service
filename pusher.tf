resource "aws_iam_user" "image_pusher" {
  #bridgecrew:skip=CKV_AWS_273: "Ensure access is controlled through SSO and not AWS IAM defined users". SSO is unavailable.
  name = "image-pusher-${local.resource_name}"
  tags = local.tags
}

resource "aws_iam_access_key" "image_pusher" {
  user = aws_iam_user.image_pusher.name
}

// The actions listed are necessary to perform actions to push ECR images
resource "aws_iam_user_policy" "image_pusher" {
  name   = "AllowECRPush"
  user   = aws_iam_user.image_pusher.name
  policy = data.aws_iam_policy_document.image_pusher.json
}

data "aws_iam_policy_document" "image_pusher" {
  statement {
    sid    = "AllowPushPull"
    effect = "Allow"

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeImages",
      "ecr:ListImages",
    ]

    resources = [aws_ecr_repository.this.arn]
  }

  statement {
    sid       = "AllowAuthorization"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
}
