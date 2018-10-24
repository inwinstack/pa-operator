VERSION_MAJOR ?= 0
VERSION_MINOR ?= 1
VERSION_BUILD ?= 0
VERSION ?= v$(VERSION_MAJOR).$(VERSION_MINOR).$(VERSION_BUILD)

GOOS ?= $(shell go env GOOS)

ORG := github.com
OWNER := inwinstack
REPOPATH ?= $(ORG)/$(OWNER)/pan-operator

$(shell mkdir -p ./out)

.PHONY: build
build: out/operator

.PHONY: out/operator
out/operator: dep
	GOOS=$(GOOS) go build \
	  -ldflags="-X $(REPOPATH)/pkg/version.version=$(VERSION)" \
	  -a -o $@ cmd/main.go

.PHONY: dep 
dep:
	dep ensure

.PHONY: test
test:
	./hack/test-go.sh

.PHONY: build_image
build_image:
	docker build -t $(OWNER)/pan-operator:$(VERSION) .

.PHONY: push_image
build_image:
	docker push $(OWNER)/pan-operator:$(VERSION)

.PHONY: clean
clean:
	rm -rf out/

