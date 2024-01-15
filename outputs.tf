output "region" {
  description = "string ||| The region the lambda was created."
  value       = data.aws_region.this.name
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
  description = "string ||| All logs are emitted to 'cloudwatch'."
}

output "log_group_name" {
  value       = module.logs.name
  description = "string ||| The name of the cloudwatch log group containing application logs."
}

output "log_reader" {
  value       = module.logs.reader
  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to read logs from Cloudwatch."
  sensitive   = true
}

output "metrics_reader" {
  value       = module.logs.reader
  description = "object({ name: string, access_key: string, secret_key: string }) ||| An AWS User with explicit privilege to read metrics from Cloudwatch."
  sensitive   = true
}

output "metrics_mappings" {
  value = local.metrics_mappings
}

output "artifact_source" {
  value       = "docker"
  description = "string ||| This module pulls its source as a docker image from ECR."
}

output "image_repo_name" {
  value       = aws_ecr_repository.this.name
  description = "string ||| The name of the docker image for the application."
}

output "image_repo_url" {
  value       = aws_ecr_repository.this.repository_url
  description = "string ||| The URL for the docker image repository for the application."
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
  description = "list(string) ||| A list of URLs only accessible inside the network."
  value       = local.private_urls
}

output "public_urls" {
  description = "list(string) ||| A list of URLs accessible to the public"
  value       = local.public_urls
}
