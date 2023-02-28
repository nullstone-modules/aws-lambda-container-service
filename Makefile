publish-bootstrap-image:
	docker build -t nullstone/lambda-bootstrap:latest .
	docker push nullstone/lambda-bootstrap:latest
lock-providers:
	terraform providers lock -platform=linux_amd64 -platform=linux_arm64 -platform=darwin_amd64 -platform=darwin_arm64 -platform=windows_amd64
