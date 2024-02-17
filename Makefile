.PHONY: run
run:
	# Start all dependencies using development configuration
	docker-compose --env-file .env.development up --detach

.PHONY: test
test:
	# Start a test container running against existing dependencies
	docker-compose --profile test up --build --force-recreate test

.PHONY: stop
stop:
	# Stop all containers belonging to the project stack
	docker-compose --env-file .env.development down
