locals {
  standard_env_vars = tomap({
    NULLSTONE_ENV = data.ns_workspace.this.env_name
  })
  env_vars = { for k, v in merge(local.standard_env_vars, var.service_env_vars) : k => v }

  bootstrap_image_uri = "${aws_ecr_repository.this.repository_url}:bootstrap"
  effective_image_uri = local.app_version == "" ? dockerless_remote_image.bootstrap.target : "${aws_ecr_repository.this.repository_url}:${local.app_version}"
}

resource "aws_lambda_function" "this" {
  function_name = local.resource_name
  role          = aws_iam_role.executor.arn
  runtime       = "provided"
  memory_size   = var.service_memory
  timeout       = var.service_timeout
  tags          = local.tags
  package_type  = "Image"
  image_uri     = local.effective_image_uri

  vpc_config {
    security_group_ids = [aws_security_group.this.id]
    subnet_ids         = local.private_subnet_ids
  }

  environment {
    variables = local.env_vars
  }
}
