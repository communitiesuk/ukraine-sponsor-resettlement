.PHONY: run
run:
	# Start all dependencies using development configuration
	docker compose up --detach
	RAILS_ENV=test bundle exec rake db:migrate
	PORT=8080 ./bin/dev

.PHONY: test
test:
	# Start a test container running against existing dependencies
	docker compose up --detach
	RAILS_ENV=test bundle exec rake db:migrate
	bundle exec rake spec

.PHONY: docker-test
docker-test:
	# Start a test container running against existing dependencies
	docker compose up --detach
	docker compose --profile test up test

.PHONY: stop
stop:
	# Stop all containers belonging to the project stack
	docker compose down
