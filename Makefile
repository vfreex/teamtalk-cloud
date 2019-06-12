all: images
images:
	buildah build-using-dockerfile -t teamtalk -f images/teamtalk/Dockerfile .
.PHONY: all images docker podman
