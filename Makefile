.PHONY: docker-bats docker-ubuntu

all: check

asdf-output:
	docker build -f Dockerfile.asdf -t alphahydrae/update-asdf-tools-asdf-output . && \
		docker run --rm alphahydrae/update-asdf-tools-asdf-output

check:
	./scripts/test

check-all: check check-docker

check-watch:
	./scripts/test --watch

check-docker: check-docker-bats check-docker-ubuntu

check-docker-bats: docker-bats
	docker run -it --rm alphahydrae/update-asdf-tools-bats-tests

check-docker-ubuntu: docker-ubuntu
	docker run -it --rm alphahydrae/update-asdf-tools-ubuntu-tests

check-docker-watch: docker
	docker run -it --rm --volume "$$PWD/bin:/code/bin:ro" --volume "$$PWD/tests:/code/tests:ro" alphahydrae/update-asdf-tools-bats-tests check-watch

docker-bats:
	docker build -f Dockerfile.test.bats -t alphahydrae/update-asdf-tools-bats-tests .

docker-ubuntu:
	docker build -f Dockerfile.test.ubuntu -t alphahydrae/update-asdf-tools-ubuntu-tests .
