.PHONY: docker

all: check

asdf-output:
	docker build -f Dockerfile.asdf -t alphahydrae/update-asdf-tools-asdf-output . && \
		docker run --rm alphahydrae/update-asdf-tools-asdf-output

check:
	./scripts/test

check-watch:
	./scripts/test --watch

check-docker: docker
	docker run -it --rm alphahydrae/update-asdf-tools-tests

check-docker-watch: docker
	docker run -it --rm --volume "$$PWD/bin:/code/bin:ro" --volume "$$PWD/tests:/code/tests:ro" alphahydrae/update-asdf-tools-tests check-watch

docker:
	docker build --quiet -t alphahydrae/update-asdf-tools-tests .
