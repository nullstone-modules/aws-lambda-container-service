publish-bootstrap-image:
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws
	docker build -t nullstone/lambda-bootstrap:latest .
	docker push nullstone/lambda-bootstrap:latest
