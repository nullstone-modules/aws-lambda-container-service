# 0.4.10 (Feb 06, 2024)
* Added support for metrics in capabilities.

# 0.4.9 (Feb 01, 2024)
* Fixed secrets policy to set resources to `[<arn>, ...]` instead of `[[<arn>,...]]`.

# 0.4.8 (Feb 01, 2024)
* Fixed usage of `for_each` in secrets policy.

# 0.4.7 (Jan 24, 2024)
* Fixed terraform lock file.

# 0.4.6 (Jan 24, 2024)
* Enabled `metrics_reader` to access Cloudwatch metrics.

# 0.4.5 (Jan 24, 2024)
* Fixed secrets policy when no secrets are specified.

# 0.4.4 (Jan 16, 2024)
* Added metrics outputs to enable real-time monitoring.

# 0.4.3 (Nov 03, 2023)
* Added `invoke_arn` to `app_metadata` for capabilities.
* Ensuring lambda has access to secrets.

# 0.4.2 (Aug 21, 2023)
* Fixed deployment issue with encrypted ECR repo.

# 0.4.1 (Aug 08, 2023)
* Updated `README.md` with application management info.

# 0.4.0 (Aug 08, 2023)
* Added compliance scanning.
* Updated `README.md`.
* Added support for dead letter queue capabilities.
* Configured ECR repository with immutability and encryption.
* Enabled concurrency execution limit of 100.
* Enabled X-Ray tracing.

# 0.3.1 (Jun 23, 2023)
* Added optional `var.command` to override image `CMD`.

# 0.3.0 (Apr 25, 2023)
* Dropped `service_` prefix from variables.

# 0.2.0 (Feb 28, 2023)
* Added support for environment variable interpolation.
* Fixed generation of capability variables when the variable has no value.
