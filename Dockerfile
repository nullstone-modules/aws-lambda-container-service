FROM alpine:3

# Lambda refuses to publish a SnapStart version of a function unless its image opts in.
# The function runs this image until the first deploy, so it must carry the opt-in label.
# See https://docs.aws.amazon.com/lambda/latest/dg/snapstart-runtime-hooks-custom.html
LABEL com.amazonaws.lambda.feature.snapstart="Allow"

USER default
HEALTHCHECK NONE
