# README

# Ukraine Sponsor Resettlement

This is the codebase for the Ruby on Rails app that will handle the submission of sponsorship requests.

## Required setup

Pre-requisites:

- Docker

### Getting started

Run:
`make run`

Alternatively, to run the rails app in the foreground so that you can see its output, run:
`make run-fg`

The Rails server should start on <http://localhost:8080>

## Database migrations

Database migrations are required to make changes to the database

`rails generate migration <name of migration>`

This will create a file in the db/migrate folder and this file can be amended to reflect the change required.

## Infrastructure

This application is running on GovUK PaaS (https://www.cloud.service.gov.uk/). To deploy, you need to:

#### Backing services

1. To create the Postgres database:\
   `cf create-service postgres tiny-unencrypted-13 ukraine-sponsor-resettlement-<target environment>-postgres`

Please note: this takes up to about 15 minutes & "tiny-unencrypted-13" is the only size available on the free tier

#### Deployments

1. Contact 1password manager to get access to the Ukraine Resettlement vault for deployment credentials

2. Install Cloud Foundry CLI (https://docs.cloudfoundry.org/cf-cli/install-go-cli.html)

3. Login:\
   `cf login -a api.london.cloud.service.gov.uk -u dluhc-ulss-deploy@madetech.com`

4. Set your deployment target environment (test/staging/):\
   `cf target -o ukraine-sponsor-resettlement -s <deployment_target_environment>`

5. Deploy:\
   `cf push ukraine-sponsor-resettlement-<target environment> --strategy rolling`

The deployment will use the manifest file based on convention (e.g. staging_manifest.yml)

6. Post-deployment - check logs:\
   `cf logs ukraine-sponsor-resettlement-<target environment> --recent`

#### Troubleshooting deployments

A failed Github deployment action will occasionally leave a Cloud Foundry
deployment in a broken state. As a result all subsequent Github deployment
actions will also fail with the message\
`Cannot update this process while a deployment is in flight`.

`cf cancel-deployment ukraine-sponsor-resettlement-<target environment>`
