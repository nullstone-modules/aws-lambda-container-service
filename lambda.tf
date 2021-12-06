locals {
  standard_env_vars = tomap({
    NULLSTONE_ENV = data.ns_workspace.this.env_name
  })
  env_vars = { for k, v in merge(local.standard_env_vars, var.service_env_vars) : k => v }
}

resource "aws_lambda_function" "this" {
  function_name = local.resource_name
  role          = aws_iam_role.executor.arn
  runtime       = local.service_runtime
  memory_size   = var.service_memory
  timeout       = var.service_timeout
  tags          = local.tags
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.this.repository_url}:${local.app_version}"

  dynamic "vpc_config" {
    for_each = local.vpc_configs

    content {
      security_group_ids = vpc_config.value["security_group_ids"]
      subnet_ids         = vpc_config.value["subnet_ids"]
    }
  }

  environment {
    variables = local.env_vars
  }
}
