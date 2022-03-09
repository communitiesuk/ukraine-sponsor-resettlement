# README

# Ukraine Sponsor Resettlement

This is the codebase for the Ruby on Rails app that will handle the submission of sponsorship requests.

## Required setup

Pre-requisites:

- Ruby
- Rails
- Postgres

### Getting started

1. Install project dependencies:\
`bundle install`

2. Install the GDS frontend dependencies:\
`yarn install`

3. Start Rails server:\
`bundle exec rails s`

The Rails server should start on <http://localhost:3000>

### Local development

1. Use the Docker command for running a Postgres Docker image\
`docker run —-name ukraine-sponsor -e POSTGRES_PASSWORD=Pass@word -d postgres`

Local instance of Postgres running in Docker; by default data will be lost when the image is stopped

## Infrastructure

This application is running on GovUK PaaS (https://www.cloud.service.gov.uk/). To deploy, you need to:

1. Contact your organisation manager to get an account in 'dluhc-ukraine-resettlement-sponsorship' organisation

2. Install Cloud Foundry CLI (https://docs.cloudfoundry.org/cf-cli/install-go-cli.html)

3. Login:\
`cf login -a api.london.cloud.service.gov.uk -u <your_username>`

4. Set your deployment target environment (sandbox/test/staging/):\
`cf target -o dluhc-ukraine-resettlement-sponsorship -s <deployment_target_environment>`

5. Deploy:\
`cf push dluhc-ukraine-resettlement-sponsorship --strategy rolling`

The deployment will use the manifest file based on convention (e.g. staging_manifest.yml)

6. Post-deployment - check logs:\
`cf logs dluhc-ukraine-resettlement-sponsorship-staging --recent`

#### Troubleshooting deployments

A failed Github deployment action will occasionally leave a Cloud Foundry 
deployment in a broken state. As a result all subsequent Github deployment 
actions will also fail with the message\
`Cannot update this process while a deployment is in flight`.

`
cf cancel-deployment dluhc-ukraine-resettlement-sponsorship
`

You'd then need to check the logs and fix the issue that caused the initial deployment to fail



Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
