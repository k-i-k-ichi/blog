# check if podman is installed, podman takes precedent over docker
DOCKER_COMMAND ?=$(shell type -p podman 2>&1 >/dev/null && echo podman || echo docker)

docker:
	echo "build docker"


build:
	# if this command fails it's likely:
	# 	- docker doesn't have permission on $REPO_DIR
	# 	- TBC
	${DOCKER_COMMAND} run --rm \
		-v $(strip ${REPO_DIR}):/smartcic:Z \
		--user=root:root \
		--pull=never ${DOCKER_IMAGE} sh -c "cd engine/proxy && go build -mod vendor"
