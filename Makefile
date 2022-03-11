.PHONY: run
run:
	docker-compose up -d

.PHONY: run-fg
run-fg:
	docker-compose up -d pg
	docker-compose up app

.PHONY: stop
stop:
	docker-compose down
