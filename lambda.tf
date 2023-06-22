locals {
  bootstrap_image_uri = "${aws_ecr_repository.this.repository_url}:bootstrap"
  effective_image_uri = local.app_version == "" ? dockerless_remote_image.bootstrap.target : "${aws_ecr_repository.this.repository_url}:${local.app_version}"
  command             = length(var.command) > 0 ? var.command : null
}

resource "aws_lambda_function" "this" {
  function_name = local.resource_name
  role          = aws_iam_role.executor.arn
  memory_size   = var.memory
  timeout       = var.timeout
  tags          = local.tags
  package_type  = "Image"
  image_uri     = local.effective_image_uri

  image_config {
    command = local.command
  }

  vpc_config {
    security_group_ids = [aws_security_group.this.id]
    subnet_ids         = local.private_subnet_ids
  }

  environment {
    variables = local.all_env_vars
  }
}
