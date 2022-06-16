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
	docker-compose up --build test

.PHONY: cf
cf:
	docker run -it --mount src=`pwd`,target=/home/piper/app,type=bind ppiper/cf-cli:latest /bin/bash

.PHONY: test-local
test-local:
	RAILS_ENV=test \
	INSTANCE_NAME=ukraine-sponsor-resettlement-test \
	DB_HOST=localhost \
	DB_USERNAME=ukraine \
	DB_DATABASE=ukraine_test \
	DB_PASSWORD=password \
	VCAP_SERVICES='{"redis":[{"instance_name":"ukraine-sponsor-resettlement-test-redis","credentials":{"uri":"redis://redis"}}],"aws-s3-bucket":[{"instance_name":"ukraine-sponsor-resettlement-test-s3","access_key_id":"access-key-id","secret_access_key":"secret-access-key","region":"eu-west-2"}]}' \
	REMOTE_API_URL=http://mock-api:8081/data \
	bundle exec rspec
