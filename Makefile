# check if podman is installed, podman takes precedent over docker
DOCKER_COMMAND ?=$(shell type -p podman 2>&1 >/dev/null && echo podman || echo docker)

docker:
	echo "build docker"
