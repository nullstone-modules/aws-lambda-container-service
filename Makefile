publish-bootstrap-image:
	docker build -t nullstone/lambda-bootstrap:latest .
	docker push nullstone/lambda-bootstrap:latest
