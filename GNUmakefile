
## If you need the root privilege, then use the "sudo docker" command instead.
DOCKER_CMD = docker
DOCKER_BUILDER = mabuilder

## Please change your docker account name
REGISTRY_LIBRARY = yasuhiroabe
REGISTRY_SERVER = docker.io

NAME = sdaps-ja
DOCKER_IMAGE = sdaps-ja
DOCKER_IMAGE_VERSION = latest

## Note: Following sections are not intended to change.

IMAGE_NAME = $(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION)
PROD_IMAGE_NAME = $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME)

.PHONY: all build build-prod tag push run stop check proj1-setup proj2-add-01tif proj2-add-02tif proj2-recognize proj2-report proj2-reporttex proj2-reporttex2 proj2-csv proj2-reset

all:
	@echo "please specify a target: make [build|build-prod|push|run|stop|check]"

build:
	$(DOCKER_CMD) build . --tag $(DOCKER_IMAGE) --add-host="archive.ubuntu.com:160.26.2.187"

build-prod:
	$(DOCKER_CMD) build . --tag $(IMAGE_NAME) --no-cache --add-host="archive.ubuntu.com:160.26.2.187"

buildx-init:
	$(DOCKER_CMD) buildx create --name $(DOCKER_BUILDER) --use

buildx-setup:
	$(DOCKER_CMD) buildx use $(DOCKER_BUILDER)
	$(DOCKER_CMD) buildx inspect --bootstrap

buildx-prod:
	$(DOCKER_CMD) buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --tag $(PROD_IMAGE_NAME) --no-cache --push .

tag:
	$(DOCKER_CMD) tag $(IMAGE_NAME) $(PROD_IMAGE_NAME)

push:
	$(DOCKER_CMD) push $(PROD_IMAGE_NAME)

run:
	$(DOCKER_CMD) run -it --rm --name $(NAME) $(DOCKER_IMAGE) setup --help

PROJ1_WORKDIR = dev.proj1

proj1-setup:
	rm -rf $(PROJ1_WORKDIR)/work
	$(DOCKER_CMD) run --rm \
		-v `pwd`/dev.proj1:/proj \
                $(PROD_IMAGE_NAME) \
		setup \
		--add translator-sdaps-dictionary-English.dict \
		work/ example-ja.tex

proj1-add:
	$(DOCKER_CMD) run --rm \
		-v `pwd`/dev.proj1:/proj \
                $(PROD_IMAGE_NAME) \
		add work/ 01.tiff

proj1-recognize:
	$(DOCKER_CMD) run --rm \
		-v `pwd`/dev.proj1:/proj \
                $(PROD_IMAGE_NAME) \
		recognize work/

proj1-reporttex:
	$(DOCKER_CMD) run --rm \
		-v `pwd`/dev.proj1:/proj \
                $(PROD_IMAGE_NAME) \
		report_tex work/

proj1-csv:
	$(DOCKER_CMD) run --rm \
		-v `pwd`/dev.proj1:/proj \
                $(PROD_IMAGE_NAME) \
		csv export work/

proj2-add-01tif:
	$(DOCKER_CMD) run --rm \
		-v `pwd`/dev.proj2:/proj \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		add 20200310_survey/ 01.tif

proj2-add-02tif:
	$(DOCKER_CMD) run --rm \
		-v `pwd`/dev.proj2:/proj \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		add 20200310_survey/ 02.tif

proj2-recognize:
	$(DOCKER_CMD) run --rm \
		-v `pwd`/dev.proj2:/proj \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		recognize 20200310_survey/

proj2-report:
	$(DOCKER_CMD) run --rm \
		-e DISPLAY=:0.0 \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v `pwd`/dev.proj2:/proj \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		report 20200310_survey/

proj2-reporttex:
	$(DOCKER_CMD) run --rm \
		-v `pwd`/dev.proj2:/proj \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		report_tex --create-tex 20200310_survey/

proj2-reporttex2:
	$(DOCKER_CMD) run --rm \
		-v `pwd`/dev.proj2:/proj \
		-v `pwd`/dev.proj2.tmp:/tmp \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		report_tex --create-tex 20200310_survey/

proj2-csv:
	$(DOCKER_CMD) run --rm \
		-v `pwd`/dev.proj2:/proj \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		csv export 20200310_survey/

proj2-reset:
	$(DOCKER_CMD) run --rm \
		-v `pwd`/dev.proj2:/proj \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		reset 20200310_survey/

stop:
	$(DOCKER_CMD) stop $(NAME)

check:
	$(DOCKER_CMD) ps -f name=$(NAME)
	@echo
	$(DOCKER_CMD) images $(IMAGE_NAME)
	@echo
	$(DOCKER_CMD) images $(PROD_IMAGE_NAME)

