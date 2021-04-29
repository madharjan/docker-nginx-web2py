
NAME = madharjan/docker-nginx-web2py
VERSION = 2.21.1

DEBUG ?= true

DOCKER_USERNAME ?= $(shell read -p "DockerHub Username: " pwd; echo $$pwd)
DOCKER_PASSWORD ?= $(shell stty -echo; read -p "DockerHub Password: " pwd; stty echo; echo $$pwd)
DOCKER_LOGIN ?= $(shell cat ~/.docker/config.json | grep "docker.io" | wc -l)

.PHONY: all build run test stop clean tag_latest release clean_images

all: build

docker_login:
ifeq ($(DOCKER_LOGIN), 1)
		@echo "Already login to DockerHub"
else
		@docker login -u $(DOCKER_USERNAME) -p $(DOCKER_PASSWORD)
endif

build:
	docker build \
		--build-arg WEB2PY_VERSION=$(VERSION) \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg WEB2PY_MIN=false \
		--build-arg DEBUG=$(DEBUG) \
		-t $(NAME):$(VERSION) --rm .

	docker build \
		--build-arg WEB2PY_VERSION=$(VERSION) \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg WEB2PY_MIN=true \
		--build-arg DEBUG=$(DEBUG) \
		-t $(NAME)-min:$(VERSION) --rm .

run:
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	
	rm -rf /tmp/web2py
	mkdir -p /tmp/web2py/full
	mkdir -p /tmp/web2py/min

	docker run -d \
		-e WEB2PY_ADMIN=Pa55word! \
		-v /tmp/web2py/full:/opt/web2py/applications \
		-e DEBUG=$(DEBUG) \
	  --name web2py $(NAME):$(VERSION)

	sleep 3

	docker run -d \
		-v /tmp/web2py/min:/opt/web2py/applications \
		-e DEBUG=$(DEBUG) \
		--name web2py_min $(NAME)-min:$(VERSION)

	sleep 2

	docker run -d \
		-e DISABLE_UWSGI=1 \
		-e DEBUG=$(DEBUG) \
		--name web2py_no_uwsgi $(NAME):$(VERSION)

	sleep 2

	docker run -d \
		-e DISABLE_NGINX=1 \
		-e DEBUG=$(DEBUG) \
		--name web2py_no_nginx $(NAME):$(VERSION)

	sleep 2

	rm -rf /tmp/web2py/app
	mkdir -p /tmp/web2py/app

	docker run -d \
		-e DEBUG=$(DEBUG) \
		-e WEB2PY_ADMIN=Pa55word! \
		-e INSTALL_PROJECT=1 \
		-e PROJECT_GIT_REPO=https://github.com/madharjan/web2py-contest.git \
		-e PROJECT_GIT_TAG=HEAD \
		-v /tmp/tmp/web2py/app:/opt/web2py/applications  \
		--name web2py_app $(NAME):$(VERSION) 

	sleep 4

test:
	sleep 3
	./bats/bin/bats test/tests.bats

stop:
	docker exec web2py /bin/bash -c "rm -rf /opt/web2py/applications/*" 2> /dev/null || true
	docker exec web2py_min /bin/bash -c "rm -rf /opt/web2py/applications/*" 2> /dev/null || true
	docker exec web2py_app /bin/bash -c "rm -rf /opt/web2py/applications/*" 2> /dev/null || true
	docker stop web2py web2py_min web2py_no_nginx web2py_no_uwsgi web2py_app 2> /dev/null || true

clean: stop
	docker rm web2py web2py_min web2py_no_nginx web2py_no_uwsgi web2py_app 2> /dev/null || true
	rm -rf /tmp/web2py || true
	rm -rf /tmp/web2py_app || true
	docker images | grep "<none>" | awk '{print$3 }' | xargs docker rmi 2> /dev/null || true

publish: docker_login run test clean
	docker push $(NAME)

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest
	docker tag $(NAME)-min:$(VERSION) $(NAME)-min:latest

release: docker_login  run test clean tag_latest
	docker push $(NAME)
	docker push $(NAME)-min

clean_images: clean
	docker rmi $(NAME):latest $(NAME):$(VERSION) 2> /dev/null || true
	docker rmi $(NAME)-min:latest $(NAME)-min:$(VERSION) 2> /dev/null || true
	docker logout 


