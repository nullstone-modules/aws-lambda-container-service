variable "memory" {
  type        = number
  default     = 128
  description = <<EOF
The amount of memory to reserve and cap the service.
If the service exceeds this amount, the service will be killed with exit code 127 representing "Out-of-memory".
Memory is measured in MiB, or megabytes.
This means the default is 128 MiB or 0.125 GiB.
EOF
}

variable "timeout" {
  type        = number
  default     = 3
  description = <<EOF
The maximum number of seconds the service is allotted to execute.
The maximum this can be set is 900 seconds (15 minutes).
EOF
}

variable "command" {
  type        = list(string)
  default     = []
  description = <<EOF
This overrides the `CMD` specified in the image.
Specify a blank list to use the image's `CMD`.
Each token in the command is an item in the list.
For example, `echo "Hello World"` would be represented as ["echo", "\"Hello World\""].
EOF
}

variable "reserved_concurrency" {
  type        = number
  default     = -1
  description = <<EOF
The number of reserved concurrent executions for this Lambda function.
This guarantees a minimum amount of concurrent executions for the function.
`-1` removes limitations and `0` disables the lambda from being triggered
EOF
}

variable "snap_start" {
  type        = bool
  default     = false
  description = <<EOF
Enable Lambda SnapStart to reduce cold start times.
AWS initializes the function once per deploy, snapshots it, and resumes from that snapshot on a cold start.
The image must opt in: AWS base images for Java 11+, Python 3.12+, and .NET 8+ work as-is;
any other image needs `LABEL com.amazonaws.lambda.feature.snapstart="Allow"` in its Dockerfile, or the deploy fails.
Deploys take longer because AWS snapshots each new version before it receives traffic.
AWS charges for each stored snapshot and for each restore.
EOF
}

variable "versions_to_keep" {
  type        = number
  default     = 3
  description = <<EOF
The number of published versions to keep when SnapStart is enabled, including the one receiving traffic.
Each deploy publishes a new version and removes older ones beyond this count.
Every kept version has a stored snapshot that AWS charges for.
EOF

  validation {
    condition     = var.versions_to_keep >= 1
    error_message = "versions_to_keep must be at least 1."
  }
}

variable "alert_thresholds" {
  type = object({
    error_rate = optional(number, 5)
  })
  default     = {}
  description = <<EOF
Thresholds for CloudWatch alarms on the lambda function. Only active when a notification connection is provided.
- error_rate: Percentage of invocations that error over a 5-minute period to trigger the alarm (default: 5%)
EOF
}
