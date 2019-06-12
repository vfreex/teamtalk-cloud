IMAGE_PREFIX:=docker.io/rayson/
IMAGE_BUILD_CMD:=docker build

all: images
images:
	$(IMAGE_BUILD_CMD) -t $(IMAGE_PREFIX)teamtalk -f images/teamtalk/Dockerfile .
.PHONY: all images docker podman
