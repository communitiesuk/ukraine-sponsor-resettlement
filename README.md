# Ukraine Sponsor Resettlement

This is the codebase for the [Ruby on Rails app](https://apply-to-offer-homes-for-ukraine.service.gov.uk/) that will handle the submission of sponsorship requests.

## Table of Contents

- [Deployment Pipeline](#deployment-pipeline)
- [System Context Diagram](#system-context-diagram)
- [Container Diagram](#container-diagram)
- [Component Diagram](#component-diagram)
- [Monitoring](#monitoring)
  - [Alerting](#alerting)
- [Related Repositories](#related-repositories)
- [Development](#development)
  - [Pre-requisites](#pre-requisites)
  - [Getting Started](#getting-started)
  - [Running Tests](#running-tests)
    - [Unit Tests](#unit-tests)
    - [Automated Tests (End to End)](#running-automated-tests-end-to-end-tests)
- [Database Migrations](#database-migrations)
- [Infrastructure](#infrastructure)

## Deployment Pipeline

![Prod Deployment Pipeline](https://github.com/communitiesuk/ukraine-sponsor-resettlement/actions/workflows/deploy-aws-production.yml/badge.svg?branch=master)
![Staging Deployment Pipeline](https://github.com/communitiesuk/ukraine-sponsor-resettlement/actions/workflows/deploy-aws-staging.yml/badge.svg?branch=master)

## System Context Diagram

The, [C4 system context diagram](https://c4model.com/#SystemContextDiagram) is intended to show, at the highest level, the key users and interactions in the system.

![C4 Context diagram](./docs/img/system-context.svg)

## Container Diagram

The,  [C4 container diagram](https://https://c4model.com/#ContainerDiagram) is intended to zoom in from the system boundary, at the highest level, to provide further detail for the technical audience.

![C4 Container diagram](./docs/img/container.svg)

## Component Diagram

The, [C4 Component diagram](https://c4model.com/#ComponentDiagram) is intended to zoom in from the system boundary, at the highest level, to provide further detail for the technical audience.

![C4 Component diagram](./docs/img/webapp_component.svg)

## Monitoring

- [sentry.io](https://sentry.io/organizations/dluhc-ulss/projects/dluhc-ulss/?project=6260319)
- [CloudWatch](https://eu-west-2.console.aws.amazon.com/cloudwatch/home?region=eu-west-2#home:)
- [PagerDuty](https://madetech.eu.pagerduty.com/service-directory/PHFCTQM)

### Alerting

Alerts are configured in CloudWatch, and push to PagerDuty via a SNS topic. Sentry also creates incidents in PagerDuty on new errors.

PagerDuty incidents go to the #msp-live-service-alerts channel in Made Tech's Slack instance

## Development

### Pre-requisites

- Docker
- [asdf](https://asdf-vm.com/guide/getting-started.html)

### Getting started

#### First time

You may need to install some supporting packages (note the instructions from brew re adding them to your PATH):

```shell
brew install icu4c libpq
```

Make sure you are using the correct tool versions:

```shell
asdf install
```

Install dependencies:

```shell
yarn install
bundle install
```

Build assets and install build tools:

```shell
# bundle exec rake webpacker:install
bundle exec rails assets:precompile
```

#### Every time
Run:

```shell
make run
```

The Rails server should start on <http://localhost:8080>

Either visit http://localhost:8080/sponsor-a-child/ or http://localhost:8080/expression-of-interest/

### Running tests

#### Unit tests

Run: `make test`

NB: This builds a Docker image and sets up an environment for running tests depending on PostgresQL, Redis and S3. The container will be destroyed when the tests complete, which means that the coverage report will be lost.

If you want the coverage report, you can keep the container alive by editing
/bin/test.sh to do

`RAILS_ENV=test rake db:prepare && rake db:migrate && rake && tail -f /dev/null`

instead of terminating when the rake task which runs the tests has finished. (`tail -f /dev/null` is a benign way of keeping the container active).

When the tests have completed you can copy the coverage report to your
docker host's local filesystem by doing

`docker cp <container ID or name>:/app/coverage <destination path on host>`

on the host.
For example, to copy to the coverage report to the current working directory on the host:

`docker cp ukraine-sponsor-resettlement-test-1:/app/coverage .`

You can then terminate the testing container with ctrl-c.

#### Running Automated tests (End to End tests)

This repository features automated tests run through [Cypress](https://www.cypress.io/).
Setup and instructions can be found [here](automated_tests/README.md)

## Database migrations

Database migrations are required to make changes to the database

`rails generate migration <name of migration>`

This will create a file in the db/migrate folder and this file can be amended to reflect the change required.

## Infrastructure

This application is running on Amazon Web Services (https://aws.amazon.com/console/) via ECS on Fargate.
