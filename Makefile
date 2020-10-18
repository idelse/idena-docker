.PHONY: default all image deploy

BUILD_TARGET    ?= idena
BUILD_VERSION   ?= 0.22.1
BUILD_COMMIT    ?= b251f609d9e7375a0b7e00f63ea2fa1754ce7240
BUILD_IMAGE     := idenadev/$(BUILD_TARGET):$(BUILD_VERSION)
BUILD_LATEST    := idenadev/$(BUILD_TARGET):latest
export BUILD_TARGET BUILD_VERSION BUILD_COMMIT BUILD_IMAGE BUILD_LATEST

BUILD_FLAGS     := --build-arg BUILD_TARGET=$(BUILD_TARGET) --build-arg BUILD_COMMIT=$(BUILD_COMMIT) --build-arg BUILD_VERSION=$(BUILD_VERSION)

all: build

build:
	docker build -f Dockerfile --pull --no-cache --rm --tag $(BUILD_IMAGE) --tag $(BUILD_LATEST) $(BUILD_FLAGS) .
	docker image prune --force --filter "label=autodelete=true"

build_cache:
	docker build -f Dockerfile --pull --rm --tag $(BUILD_IMAGE) --tag $(BUILD_LATEST) $(BUILD_FLAGS) .
	docker image prune --force --filter "label=autodelete=true"

publish:
	docker push idenadev/idena:$(BUILD_VERSION)

latest:
	docker push idenadev/idena:latest
