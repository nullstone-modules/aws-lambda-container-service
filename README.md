# Lambda Application (using Containers)

Create a Nullstone application that is served through AWS Lambda using a Docker image.

This application module creates an AWS Lambda using the Docker runtime that AWS Lambda offers.

## When to use

AWS Lambda is a great choice for applications that require short bursts of execution (< 15 minutes).
There are no servers to manage.
Security and deployment are controlled explicitly through infrastructure code.

This variant of Lambda uses Docker images which provides a great level of flexibility and portability.
However, using Docker images has a longer cold start (initial execution takes longer) because AWS has to pull the image.
Use this module if cold start is not a concern, or you can minimize the size/change of the top Docker image layer.

## Security & Compliance

Security scanning is graciously provided by [Bridgecrew](https://bridgecrew.io/).
Bridgecrew is the leading fully hosted, cloud-native solution providing continuous Terraform security and compliance.

![Infrastructure Security](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-lambda-service/general)
![CIS AWS V1.3](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-lambda-service/cis_aws_13)
![PCI-DSS V3.2](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-lambda-service/pci)
![NIST-800-53](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-lambda-service/nist)
![ISO27001](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-lambda-service/iso)
![SOC2](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-lambda-service/soc2)
![HIPAA](https://www.bridgecrew.cloud/badges/github/nullstone-modules/aws-lambda-service/hipaa)

## Network Access

Nullstone places the Lambda Function into private subnets for the connected network.
As a result, the Lambda Function can route to services on the private network.

## Execution

This application module supports various capabilities to handle execution of a Lambda Function.
- Ingress: Enables public access to execute Lambda as HTTP Request (e.g. API Gateway capabilities)
- Trigger: Enable events to execute Lambda (e.g. Cron Trigger, SQS Queue)
- CLI Execution: `nullstone exec` (See [`exec`](https://docs.nullstone.io/getting-started/cli/docs.html#exec) for more information)

## SnapStart

Set `snap_start = true` to reduce cold start times with [Lambda SnapStart](https://docs.aws.amazon.com/lambda/latest/dg/snapstart.html).
AWS initializes the function once per deploy, takes a snapshot, and resumes from that snapshot on a cold start.

- **Your image must opt in.** AWS base images for Java 11+, Python 3.12+, and .NET 8+ work as-is.
  Any other image needs `LABEL com.amazonaws.lambda.feature.snapstart="Allow"` in its Dockerfile (or must implement the [restore runtime API](https://docs.aws.amazon.com/lambda/latest/dg/snapstart-runtime-hooks-custom.html)). Without it, the deploy fails.
- **Traffic goes through an alias.** SnapStart does not apply to `$LATEST`, so this module creates a `live` alias and points every trigger and ingress at it.
  Each deploy publishes a new version, waits for AWS to snapshot it, then moves the alias. Deploys take longer as a result.
- **Old versions are removed.** A deploy keeps the newest `versions_to_keep` versions (default 3). AWS charges for each stored snapshot and for each restore.
- **Initialization runs once, not per cold start.** Anything unique or short-lived created during initialization (random seeds, connections, temporary credentials) is shared by every environment restored from the snapshot. Create those in the handler or in an after-restore hook.
- SnapStart cannot be combined with provisioned concurrency, EFS, or more than 512 MB of ephemeral storage.

## Logs

Logs are automatically emitted to AWS Cloudwatch Log Group: `/aws/lambda/<function-name>`.
To access through the Nullstone CLI, use `nullstone logs` CLI command. (See [`logs`](https://docs.nullstone.io/getting-started/cli/docs.html#logs) for more information)

## Secrets

Nullstone cannot automatically inject secrets into your Lambda application.
Instead, Nullstone injects environment variables that refer to secrets stored in AWS Secrets Manager.
If the Nullstone app has a secret `POSTGRES_URL`, Nullstone will inject `POSTGRES_URL_SECRET_ID` that contains the Secrets Manager Secret ID to retrieve.

For more information on how to retrieve secrets for your language, check out [Retrieve secrets from AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/retrieving-secrets.html).

## Additional Resources

- [Working with Lambda container images](https://docs.aws.amazon.com/lambda/latest/dg/images-create.html)
- [Deployer container images](https://docs.aws.amazon.com/lambda/latest/dg/nodejs-image.html)
