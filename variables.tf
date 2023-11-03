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
