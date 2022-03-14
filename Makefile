.PHONY: run
run:
	docker-compose up -d

.PHONY: run-fg
run-fg:
	docker-compose up -d pg
	docker-compose up -d redis
	docker-compose up --build app

.PHONY: stop
stop:
	docker-compose down

.PHONY: test
test:
	docker-compose up test
