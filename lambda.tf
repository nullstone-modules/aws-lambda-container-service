#bridgecrew:skip=CKV_AWS_173: Skipping "Check encryption settings for Lambda environmental variable". Nullstone doesn't put secrets into environment variables.
#bridgecrew:skip=CKV_AWS_272: Skipping "Ensure AWS Lambda function is configured to validate code-signing". This module uses a docker image that cannot be code-signed.
locals {
  bootstrap_image_uri = "${aws_ecr_repository.this.repository_url}:bootstrap"
  effective_image_uri = local.app_version == "" ? dockerless_remote_image.bootstrap.target : "${aws_ecr_repository.this.repository_url}:${local.app_version}"
  command             = length(var.command) > 0 ? var.command : null
}

resource "aws_lambda_function" "this" {
  function_name                  = local.resource_name
  role                           = aws_iam_role.executor.arn
  memory_size                    = var.memory
  timeout                        = var.timeout
  tags                           = local.tags
  package_type                   = "Image"
  image_uri                      = local.effective_image_uri
  reserved_concurrent_executions = 100

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

  tracing_config {
    mode = "Active"
  }

  dynamic "dead_letter_config" {
    for_each = local.dead_letter_queues

    content {
      target_arn = dead_letter_config.value.queue_arn
    }
  }
}
