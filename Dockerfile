# syntax = docker/dockerfile:1

FROM golang:1.18-alpine as builder
WORKDIR /src
COPY go.* ./
RUN go mod download
COPY . ./
RUN --mount=type=cache,target=/root/.cache/go-build go build -o app .

FROM public.ecr.aws/lambda/go:1
COPY --from=builder /src/app ${LAMBDA_TASK_ROOT}
CMD ["app"]
