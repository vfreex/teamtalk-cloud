IMAGE_PREFIX:=localhost/
IMAGE_BUILD_CMD:=docker build

all: images
images:
	$(IMAGE_BUILD_CMD) -t $(IMAGE_PREFIX)teamtalk -f images/teamtalk/Dockerfile .
.PHONY: all images docker podman
