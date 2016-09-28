
NAME = madharjan/docker-nginx-web2py
VERSION = 2.14.6

.PHONY: all build run tests clean tag_latest release clean_images

all: build

build:
	docker build \
		--build-arg WEB2PY_VERSION=$(VERSION) \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg WEB2PY_MIN=false \
		--build-arg DEBUG=true \
		-t $(NAME):$(VERSION) --rm .

	docker build \
		--build-arg WEB2PY_VERSION=$(VERSION) \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg WEB2PY_MIN=true \
		--build-arg DEBUG=true \
		$(NAME)-min:$(VERSION) --rm .

run:
	rm -rf /tmp/web2py
	mkdir -p /tmp/web2py/full
	mkdir -p /tmp/web2py/min

	docker run -d \
		-e WEB2PY_ADMIN=Pa55word! \
	  -v /tmp/web2py/full:/opt/web2py/applications \
		-e DEBUG=true \
	  --name web2py $(NAME):$(VERSION)

	docker run -d \
	  -v /tmp/web2py/min:/opt/web2py/applications \
		-e DEBUG=true \
	  --name web2py_min $(NAME)-min:$(VERSION)

	docker run -d \
		-e DISABLE_UWSGI=1 \
		-e DEBUG=true \
	  --name web2py_no_uwsgi $(NAME):$(VERSION)

	docker run -d \
		-e DISABLE_NGINX=1 \
		-e DEBUG=true \
	  --name web2py_no_nginx $(NAME):$(VERSION)

tests:
	./bats/bin/bats test/tests.bats

clean:
	docker exec web2py /bin/bash -c "rm -rf /opt/web2py/applications/*" || true
	docker exec web2py_min /bin/bash -c "rm -rf /opt/web2py/applications/*" || true
	docker stop web2py web2py_min web2py_no_nginx web2py_no_uwsgi || true
	docker rm web2py web2py_min web2py_no_nginx web2py_no_uwsgi || true
	rm -rf /tmp/web2py || true

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
	curl -X POST https://hooks.microbadger.com/images/madharjan/docker-nginx-web2py/evcn6a67rZc_UychWDShxAocMnE=

clean_images:
	docker rmi $(NAME):latest $(NAME):$(VERSION) || true
	docker rmi $(NAME)-min:latest $(NAME)-min:$(VERSION) || true
