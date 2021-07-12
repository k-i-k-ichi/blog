
CUR_DIR=$(pwd)
# check if podman is installed, podman takes precedent over docker
DOCKER_COMMAND ?=$(shell type -p podman 2>&1 >/dev/null && echo podman || echo docker)

DOCKER_IMAGE=blog
DOCKER_OPTS= -v $(shell pwd):/blog:Z

docker:
	echo "build docker"


image:
	${DOCKER_COMMAND} build --no-cache -t ${DOCKER_IMAGE} .

build:
	# if this command fails it's likely:
	# 	- docker doesn't have permission on $REPO_DIR
	# 	- TBC

# Q: Why not use run command in docker-compose ?
# A: It's not even available for podman
run_test:
	${DOCKER_COMMAND} run --rm -it ${DOCKER_IMAGE} /bin/bash
