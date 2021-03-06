RPM_PATH = "iguazio_yum"
DEB_PATH = "iguazio_deb"
BINARY_NAME = "igz-fuse"
RELEASE_VERSION = "0.6.0"
DOCKER_HUB_USER = "iguaziodocker"

.PHONY: build
build:
	docker build --tag $(DOCKER_HUB_USER)/flex-fuse:unstable .

.PHONY: download
download:
	@rm -rf hack/libs/${BINARY_NAME}*
	@cd hack/libs && wget --quiet $(MIRROR)/$(RPM_PATH)/$(IGUAZIO_VERSION)/$(BINARY_NAME).rpm
	@cd hack/libs && wget --quiet $(MIRROR)/$(DEB_PATH)/$(IGUAZIO_VERSION)/$(BINARY_NAME).deb
	@touch hack/libs/$(IGUAZIO_VERSION)

.PHONY: release
release: check-req download build
	docker tag $(DOCKER_HUB_USER)/flex-fuse:unstable $(DOCKER_HUB_USER)/flex-fuse:$(IGUAZIO_VERSION:igz_%=%)-$(RELEASE_VERSION)

check-req:
ifndef MIRROR
	$(error MIRROR must be set)
endif
ifndef IGUAZIO_VERSION
	$(error IGUAZIO_VERSION must be set)
endif
ifndef RELEASE_VERSION
	$(error RELEASE_VERSION must be set)
endif
