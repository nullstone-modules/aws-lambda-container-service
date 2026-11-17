locals {
  bootstrap_image_uri = "${aws_ecr_repository.this.repository_url}:bootstrap"
  effective_image_uri = local.app_version == "" ? dockerless_remote_image.bootstrap.target : "${aws_ecr_repository.this.repository_url}:${local.app_version}"
  command             = length(var.command) > 0 ? var.command : null

  // SnapStart only applies to published versions, never `$LATEST`.
  // When enabled, triggers invoke this alias and each deploy moves it to a newly published version.
  // The name is fixed so `app_metadata` can build alias ARNs without depending on the function (see app.tf).
  live_alias_name    = "live"
  function_qualifier = var.snap_start ? local.live_alias_name : null
}

resource "aws_lambda_alias" "live" {
  count = var.snap_start ? 1 : 0

  name          = local.live_alias_name
  description   = "The version receiving traffic. Moved by Nullstone on each deploy."
  function_name = aws_lambda_function.this.function_name
  // `version` tracks the latest published version, including versions published by a deploy,
  // so an apply after a deploy does not move the alias backwards.
  function_version = aws_lambda_function.this.version
}

resource "aws_lambda_function" "this" {
  #bridgecrew:skip=CKV_AWS_272: Skipping "Ensure AWS Lambda function is configured to validate code-signing". This module uses a docker image that cannot be code-signed.
  function_name                  = local.resource_name
  role                           = module.scaffold.executor.arn
  memory_size                    = var.memory
  timeout                        = var.timeout
  tags                           = local.tags
  package_type                   = "Image"
  image_uri                      = local.effective_image_uri
  reserved_concurrent_executions = var.reserved_concurrency
  kms_key_arn                    = module.scaffold.kms_key.arn
  publish                        = var.snap_start

  dynamic "snap_start" {
    for_each = var.snap_start ? [1] : []

    content {
      apply_on = "PublishedVersions"
    }
  }

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
