// This is a bit odd - we're creating a repository for every environment
// We need to find a better way to do this
resource "aws_ecr_repository" "this" {
  name = local.resource_name
  tags = data.ns_workspace.this.tags
}

resource "aws_ecr_repository_policy" "this" {
  policy     = data.aws_iam_policy_document.ecr_lambda_access.json
  repository = aws_ecr_repository.this.name
}

data "aws_iam_policy_document" "ecr_lambda_access" {
  statement {
    sid    = "LambdaECRImageRetrievalPolicy"
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = [
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
  }
}