
NAME = sdaps-ja
DOCKER_IMAGE = sdaps-ja
DOCKER_IMAGE_VERSION = ub2004-2

IMAGE_NAME = $(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION)

REGISTRY_SERVER = docker.io
REGISTRY_LIBRARY = yasuhiroabe

PROD_IMAGE_NAME = $(REGISTRY_SERVER)/$(REGISTRY_LIBRARY)/$(IMAGE_NAME)

.PHONY: all build build-prod tag push run stop check proj1-setup proj2-add-01tif proj2-add-02tif proj2-recognize proj2-report proj2-reporttex proj2-reporttex2 proj2-csv proj2-reset

all:
	@echo "please specify a target: make [build|build-prod|push|run|stop|check]"

build:
	sudo docker build . --tag $(DOCKER_IMAGE)

build-prod:
	sudo docker build . --tag $(IMAGE_NAME) --no-cache

tag:
	sudo docker tag $(IMAGE_NAME) $(PROD_IMAGE_NAME)

push:
	sudo docker push $(PROD_IMAGE_NAME)

run:
	sudo docker run -it --rm --name $(NAME) $(DOCKER_IMAGE) setup --help

proj1-setup:
	sudo docker run --rm \
		-v `pwd`/dev.proj1:/proj \
                $(PROD_IMAGE_NAME) \
		setup \
		--add translator-sdaps-dictionary-English.dict \
		work/ example-ja.tex

proj1-add:
	sudo docker run --rm \
		-v `pwd`/dev.proj1:/proj \
                $(PROD_IMAGE_NAME) \
		add work/ 01.tiff

proj1-recognize:
	sudo docker run --rm \
		-v `pwd`/dev.proj1:/proj \
                $(PROD_IMAGE_NAME) \
		recognize work/

proj1-reporttex:
	sudo docker run --rm \
		-v `pwd`/dev.proj1:/proj \
                $(PROD_IMAGE_NAME) \
		report_tex work/

proj1-csv:
	sudo docker run --rm \
		-v `pwd`/dev.proj1:/proj \
                $(PROD_IMAGE_NAME) \
		csv export work/

proj2-add-01tif:
	sudo docker run --rm \
		-v `pwd`/dev.proj2:/proj \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		add 20200310_survey/ 01.tif

proj2-add-02tif:
	sudo docker run --rm \
		-v `pwd`/dev.proj2:/proj \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		add 20200310_survey/ 02.tif

proj2-recognize:
	sudo docker run --rm \
		-v `pwd`/dev.proj2:/proj \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		recognize 20200310_survey/

proj2-report:
	sudo docker run --rm \
		-e DISPLAY=:0.0 \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-v `pwd`/dev.proj2:/proj \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		report 20200310_survey/

proj2-reporttex:
	sudo docker run --rm \
		-v `pwd`/dev.proj2:/proj \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		report_tex --create-tex 20200310_survey/

proj2-reporttex2:
	sudo docker run --rm \
		-v `pwd`/dev.proj2:/proj \
		-v `pwd`/dev.proj2.tmp:/tmp \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		report_tex --create-tex 20200310_survey/

proj2-csv:
	sudo docker run --rm \
		-v `pwd`/dev.proj2:/proj \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		csv export 20200310_survey/

proj2-reset:
	sudo docker run --rm \
		-v `pwd`/dev.proj2:/proj \
		--name $(NAME) \
                $(DOCKER_IMAGE) \
		reset 20200310_survey/

stop:
	sudo docker stop $(NAME)

check:
	sudo docker ps -f name=$(NAME)
	@echo
	sudo docker images $(IMAGE_NAME)
	@echo
	sudo docker images $(PROD_IMAGE_NAME)

