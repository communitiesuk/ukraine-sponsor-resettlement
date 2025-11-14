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

# Start the webapp in a docker container
.PHONY: run-docker
run-webapp-docker:
	docker compose --profile run up webapp --detach
	make db-migrate-docker

.PHONY: test
test:
	# Start a test container running against existing dependencies
	docker compose up --detach
	make db-migrate
	RAILS_ENV=test bundle exec rake spec

# Eternal dependencies required to support the webapp
.PHONY: service-deps
docker-deps:
	docker compose up --detach

# Start a test container running against existing dependencies
.PHONY: docker-test
docker-test: service-deps
	docker compose --profile test up test

.PHONY: cypress-e2e-test
cypress-e2e-test: docker-deps
	./bin/cypress-e2e-test

.PHONY: stop
stop:
	# Stop all containers belonging to the project stack
	docker compose down

.PHONY: db-migrate
db-migrate:
	RAILS_ENV=test bundle exec rake db:migrate

# Run DB migrations against a docker-compose running copy of the webapp
.PHONE: db-migrate-docker
db-migrate-docker:
	docker compose --profile run exec webapp "bundle" "exec" "rake" "db:migrate"
