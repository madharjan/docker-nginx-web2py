
NAME = madharjan/docker-nginx-web2py
VERSION = 2.14.6

.PHONY: all build build_test clean_images test tag_latest release

all: build

build:
	docker build -t $(NAME):$(VERSION) --rm .
	docker build --build-arg WEB2PY_MIN=true -t $(NAME)-min:$(VERSION) --rm .

build_test:
	docker build --build-arg DEBUG=true -t $(NAME):$(VERSION) --rm .
	docker build --build-arg WEB2PY_MIN=true --build-arg DEBUG=true -t $(NAME)-min:$(VERSION) --rm .

clean_images:
	docker rmi $(NAME):latest $(NAME):$(VERSION) || true
	docker rmi $(NAME)-min:latest $(NAME)-min:$(VERSION) || true

test:
	env NAME=$(NAME) VERSION=$(VERSION) ./test/test.sh
	env NAME=$(NAME)-min VERSION=$(VERSION) ./test/test.sh

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest
	docker tag $(NAME)-min:$(VERSION) $(NAME)-min:latest

release: test tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-min | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-min version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
	docker push $(NAME)
	docker push $(NAME)-min
	@echo "*** Don't forget to create a tag. git tag $(VERSION) && git push origin $(VERSION) ***"
