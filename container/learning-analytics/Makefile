image_name=learning-analytics-nifi
major_version=1
minor_version=0
local_image=serlo/$(image_name)

#patch version is automatically generated from minor_version + number of commits so we do not need to maintain it

include ../../mk/dockerci.mk

.PHONY: build_image
build_image:
	docker images | grep $(local_image) && echo "image $(local_image) already exists use build_image_forced" || $(MAKE) docker_build

.PHONY: docker_build
# build docker container
docker_build:
	echo "Hello world"
	#docker build --build-arg git_revision=$(shell git log | head -n 1 | cut  -f 2 -d ' ') --build-arg cron_pattern="$(cron_pattern)" -t $(local_image) .

.PHONY: docker-run
# run docker container
docker_run:
	docker run --network=host -e KPI_DATABASE_HOST=$(shell minikube ip) --env-file docker.env --rm $(local_image):latest


