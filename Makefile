
NAME = madharjan/docker-nginx-web2py
VERSION = 2.18.3

DEBUG ?= true

.PHONY: all build run tests stop clean tag_latest release clean_images

all: build

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

tests:
	sleep 3
	./bats/bin/bats test/tests.bats

stop:
	docker exec web2py /bin/bash -c "rm -rf /opt/web2py/applications/*" || true
	docker exec web2py_min /bin/bash -c "rm -rf /opt/web2py/applications/*" || true
	docker exec web2py_app /bin/bash -c "rm -rf /opt/web2py/applications/*" || true
	docker stop web2py web2py_min web2py_no_nginx web2py_no_uwsgi web2py_app || true

clean: stop
	docker rm web2py web2py_min web2py_no_nginx web2py_no_uwsgi web2py_app || true
	rm -rf /tmp/web2py || true
	rm -rf /tmp/web2py_app || true

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest
	docker tag $(NAME)-min:$(VERSION) $(NAME)-min:latest

release: run tests clean tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! docker images $(NAME)-min | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-min version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	docker push $(NAME)
	docker push $(NAME)-min
	@echo "*** Don't forget to create a tag. git tag $(VERSION) && git push origin $(VERSION) ***"
	curl -s -X POST https://hooks.microbadger.com/images/$(NAME)/evcn6a67rZc_UychWDShxAocMnE=
	curl -s -X POST https://hooks.microbadger.com/images/$(NAME)-min/CpU1SAWEalplATynvPpglQR7a04=

clean_images:
	docker rmi $(NAME):latest $(NAME):$(VERSION) || true
	docker rmi $(NAME)-min:latest $(NAME)-min:$(VERSION) || true
