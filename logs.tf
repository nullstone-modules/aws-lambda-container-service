module "logs" {
  source  = "nullstone-modules/logs/aws"
  version = "~>0.1.0"

  // NOTE: This name must be `/aws/lambda/{function_name}` to properly collect logs from function
  name              = "/aws/lambda/${local.resource_name}"
  tags              = local.tags
  enable_log_reader = true
}
