.PHONY: prepare
prepare:
	# Install required runtimes, dependencies etc.
	asdf install
	yarn install
	bundle install
	bundle exec rails assets:precompile

.PHONY: run
run:
	# Start all dependencies using development configuration
	docker compose up --detach
	make db-migrate
	PORT=8080 ./bin/dev

.PHONY: test
test:
	# Start a test container running against existing dependencies
	docker compose up --detach
	make db-migrate
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

.PHONY: db-migrate
db-migrate:
	RAILS_ENV=test bundle exec rake db:migrate
