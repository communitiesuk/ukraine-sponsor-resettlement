![Deployment Pipeline](https://github.com/communitiesuk/ukraine-sponsor-resettlement/actions/workflows/deploy-pipeline.yml/badge.svg?branch=master)

# Ukraine Sponsor Resettlement

This is the codebase for the [Ruby on Rails app](https://apply-to-offer-homes-for-ukraine.service.gov.uk/) that will handles the submission of sponsorship requests.

## System Context Diagram

The, [C4 system context diagram](https://c4model.com/#SystemContextDiagram) is intended to show, at the highest level, the key users and interactions in the system.

![C4 Context diagram](./docs/img/system-context.svg)

## Container Diagram

The,  [C4 container diagram](https://https://c4model.com/#ContainerDiagram) is intended to zoom in from the system boundary, at the highest level, to provide further detail for the technical audience.

![C4 Container diagram](./docs/img/container_aws.svg)

## Component Diagram

The,  [C4 Component diagram](https://c4model.com/#ComponentDiagram) is intended to zoom in from the system boundary, at the highest level, to provide further detail for the technical audience.

![C4 Component diagram](./docs/img/webapp_component_aws.svg)

## Monitoring

- [sentry.io](https://sentry.io/organizations/dluhc-ulss/projects/dluhc-ulss/?project=6260319)
- [logit.io Dashboard](https://dashboard.logit.io/a/6b6785a5-cb7f-4d9b-a456-456949f5aa07)
- [Grafana Production Dashboard](https://ukraine-sponsor-resettlement-monitoring-grafana.london.cloudapps.digital/d/0it5-vEnk/production)

### Alerting

Alerts are configured in [Grafana](https://ukraine-sponsor-resettlement-monitoring-grafana.london.cloudapps.digital/d/0it5-vEnk/production) and push to the following destinations:

- **#homes-for-ukraine-alerts**, [DLUHC](https://www.gov.uk/government/organisations/department-for-levelling-up-housing-and-communities) managed Slack channel
- [PagerDuty](https://madetech.eu.pagerduty.com/), MadeTech managed instance.
- Email to the team. (Find the email address defined in the grafana alerts)

### Related Repositories

- [Prometheus Exporter](https://github.com/communitiesuk/ukraine-sponsor-resettlement-monitoring) repository
- [Gov PAAS Prometheus Exporter](https://github.com/alphagov/paas-prometheus-exporter), documents the [metrics](https://github.com/alphagov/paas-prometheus-exporter#available-application-metrics) available in Grafana.

## Development

### Pre-requisites

- Docker

### Getting started

Run:
`make run`

Alternatively, to run the rails app in the foreground so that you can see its output, run:
`make run-fg`

The Rails server should start on <http://localhost:8080>

### Running tests

Run: `make test`

NB: The container will be destroyed when the tests complete, which means that the coverage report will be lost.

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

## Database migrations

Database migrations are required to make changes to the database

`rails generate migration <name of migration>`

This will create a file in the db/migrate folder and this file can be amended to reflect the change required.

## Infrastructure

This application is running on Amazon Web Services (https://aws.amazon.com/console/).

#### Automated tests

This repository features automated tests run through [Cypress](https://www.cypress.io/).
Setup and instructions can be found [here](automated_tests/README.md)
