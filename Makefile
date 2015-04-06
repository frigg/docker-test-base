TAG=frigg-test-base

all: setup run

setup:
	docker build -t $(TAG) .

run:
	docker run -i $(TAG)

killall:
	docker kill $(docker ps | grep worker | awk '{print $1}')

.PHONY: setup run killall
