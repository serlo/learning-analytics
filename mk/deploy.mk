#
# Describes deployment to the serlo cluster.
#

# location of the current serlo database dump
export dump_location ?= gs://serlo_dev_terraform/sql-dumps/dump-2019-05-13.zip

# set the appropriate docker environment
ifeq ($(env_name),minikube)
	DOCKER_ENV ?= $(shell minikube docker-env)
	env_folder = minikube/kpi
else
    	DOCKER_ENV ?= ""
    	env_folder = "live/$(env_name)"
endif

.PHONY: terraform_init
# initialize terraform in the infrastructure repository
terraform_init:
	$(MAKE) -C $(infrastructure_repository)/$(env_folder) terraform_init

.PHONY: terraform_plan
# plan the terraform provisioning in the cluster
terraform_plan: terraform_init
	$(MAKE) -C $(infrastructure_repository)/$(env_folder) terraform_plan

.PHONY: terraform_apply
# apply the terraform provisoining in the cluster
terraform_apply: terraform_init
	if [ "$(env_name)" = "minikube" ] ; then $(MAKE) build_images; fi
	$(MAKE) -C $(infrastructure_repository)/$(env_folder) terraform_apply

.PHONY: build_images
.ONESHELL:
# build docker images for local dependencies in the cluster
build_images:
	@eval "$(DOCKER_ENV)"
	for build in container/*/; do $(MAKE) -C $$build build_image || exit 1; done

.PHONY: build_images_forced
.ONESHELL:
# build docker images for local dependencies in the cluster
build_images_forced:
	@eval "$(DOCKER_ENV)"
	for build in container/*/; do $(MAKE) -C $$build docker_build || exit 1; done

.NOTPARALLEL:
