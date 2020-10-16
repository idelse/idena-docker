.PHONY: default all image deploy

BUILD_TARGET    ?= idena
BUILD_VERSION   ?= 0.20.0
BUILD_COMMIT    ?= 728d9e1db99dd92d5a61bfa4fc358f9a7a2762a5
BUILD_IMAGE     := idenadev/$(BUILD_TARGET):$(BUILD_VERSION)
BUILD_LATEST    := idenadev/$(BUILD_TARGET):latest
export BUILD_TARGET BUILD_VERSION BUILD_COMMIT BUILD_IMAGE BUILD_LATEST

BUILD_FLAGS     := --build-arg BUILD_TARGET=$(BUILD_TARGET) --build-arg BUILD_COMMIT=$(BUILD_COMMIT)

all: build

build:
	docker build -f Dockerfile --pull --no-cache --rm --tag $(BUILD_IMAGE) --tag $(BUILD_LATEST) $(BUILD_FLAGS) .
	docker image prune --force --filter "label=autodelete=true"

publish:
	docker push idenadev/idena:$(BUILD_VERSION)

latest:
	docker push idenadev/idena:latest
