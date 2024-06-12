
## If you need the root privilege, then use the "sudo docker" command instead.
DOCKER_CMD = podman
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

.PHONY: all
all:
	@echo "please specify a target: make [build|build-prod|push|run|stop|check]"

.PHONY: build
build:
	$(DOCKER_CMD) build . --pull --tag $(DOCKER_IMAGE)

.PHONY: build-prod
build-prod:
	$(DOCKER_CMD) build . --pull --tag $(IMAGE_NAME)

.PHONY: buildx-init
buildx-init:
	$(DOCKER_CMD) buildx create --name $(DOCKER_BUILDER) --use

.PHONY: buildx-setup
buildx-setup:
	$(DOCKER_CMD) buildx use $(DOCKER_BUILDER)
	$(DOCKER_CMD) buildx inspect --bootstrap

.PHONY: buildx-prod
buildx-prod:
	$(DOCKER_CMD) buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --tag $(PROD_IMAGE_NAME) --no-cache --push .

.PHONY: tag
tag:
	$(DOCKER_CMD) tag $(IMAGE_NAME) $(PROD_IMAGE_NAME)

.PHONY: push
push:
	$(DOCKER_CMD) push $(PROD_IMAGE_NAME)

proj/example.tex:
	mkdir -p proj
	chmod a+rwX,g+s proj
	wget -O proj/example.tex https://gist.githubusercontent.com/YasuhiroABE/db17793accd37b5bbe787597bd503190/raw/sdaps-example-ja.tex

.PHONY: sdaps-setup
sdaps-setup: proj/example.tex
	$(DOCKER_CMD) run -it --rm --name $(NAME) \
		-v `pwd`/proj:/proj \
		$(IMAGE_NAME) setup tex work example.tex

proj/01.tiff:
	@echo "Please placed the scanned sheet as proj/01.tiff"

PHONY: sdaps-add
sdaps-add: proj/01.tiff
	$(DOCKER_CMD) run -it --rm --name $(NAME) \
		-v `pwd`/proj:/proj \
		$(IMAGE_NAME) add work 01.tiff

PHONY: sdaps-recognize
sdaps-recognize:
	$(DOCKER_CMD) run -it --rm --name $(NAME) \
		-v `pwd`/proj:/proj \
		$(IMAGE_NAME) recognize work

PHONY: sdaps-report-tex
sdaps-report-tex:
	$(DOCKER_CMD) run -it --rm --name $(NAME) \
		-v `pwd`/proj:/proj \
		$(IMAGE_NAME) report tex work

PHONY: sdaps-report-reportlab
sdaps-report-reportlab:
	$(DOCKER_CMD) run -it --rm --name $(NAME) \
		-v `pwd`/proj:/proj \
		$(IMAGE_NAME) report reportlab work

PHONY: sdaps-csv
sdaps-csv:
	$(DOCKER_CMD) run -it --rm --name $(NAME) \
		-v `pwd`/proj:/proj \
		$(IMAGE_NAME) export csv work

PHONY: sdaps-reset
sdaps-reset:
	$(DOCKER_CMD) run -it --rm --name $(NAME) \
		-v `pwd`/proj:/proj \
		$(IMAGE_NAME) reset work

.PHONY: check
check:
	$(DOCKER_CMD) ps -f name=$(NAME)
	@echo
	$(DOCKER_CMD) images $(IMAGE_NAME)
	@echo
	$(DOCKER_CMD) images $(PROD_IMAGE_NAME)

.PHONY: clean
clean:
	find . -name '*~' -type f -exec rm -f {} \; -print
