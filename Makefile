.PHONY: default all image deploy

BUILD_TARGET    ?= idena
BUILD_VERSION   ?= 0.20.0
BUILD_COMMIT    ?= 8fa06634694d85c1fcac6e24d3b498a6f6cb59e4
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
