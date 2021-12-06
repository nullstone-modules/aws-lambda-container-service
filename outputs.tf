output "region" {
  value = data.aws_region.this.name
}
output "deployer" {
  value = {
    name       = aws_iam_user.deployer.name
    access_key = aws_iam_access_key.deployer.id
    secret_key = aws_iam_access_key.deployer.secret
  }

  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to deploy to the S3 bucket."

  sensitive = true
}

output "lambda_name" {
  value       = aws_lambda_function.this.function_name
  description = "string ||| Lambda Function Name"
}

output "lambda_arn" {
  value       = aws_lambda_function.this.arn
  description = "string ||| Lambda Function ARN"
}

output "log_provider" {
  value       = "cloudwatch"
  description = "string ||| "
}

output "log_group_name" {
  value       = module.logs.name
  description = "string ||| "
}

output "log_reader" {
  value       = module.logs.reader
  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to read logs from Cloudwatch."
  sensitive   = true
}

output artifact_source {
  value       = "docker"
  description = "string ||| This module pulls its source as a docker image from ECR."
}

output "image_repo_name" {
  value       = aws_ecr_repository.this.name
  description = "string ||| "
}

output "image_repo_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "string ||| "
}

output "image_pusher" {
  value = {
    name       = aws_iam_user.image_pusher.name
    access_key = aws_iam_access_key.image_pusher.id
    secret_key = aws_iam_access_key.image_pusher.secret
  }

  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to push images."

  sensitive = true
}

output "private_urls" {
  value = [for url in try(local.capabilities.private_urls, []) : url["url"]]
}

output "public_urls" {
  value = [for url in try(local.capabilities.public_urls, []) : url["url"]]
}
