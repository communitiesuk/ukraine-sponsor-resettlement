# Cypress-framework: UI testing

##Pre requisites
You need to have npm installed to be able to run the tests on your local

## Usage

Install npm & cypress dependencies

- cd `automated tests` directory
- run `npm install`
- run `npm run cy_verify` to verify cypress installation

Test Runner

_**IMPORTANT: The tests will be run against a local running instance of the project**_

\_To run them against a staging/live instance, please use [the --env override](https://docs.cypress.io/guides/guides/environment-variables#Option-4-env)

`npm run cy_open --env baseUrl="https://my.site.com/test"`

- run `npm run cy_open` to open cypress test runnner
- select & run test(s)
- select `run_all_specs` to run all tests

Command line
- run `all=specs npm run e2e` to run all tests using default Electron broswer and open the report
- run `npm run view_report` to view report on browser
- run `npm run headless` to run all tests headless mode
- run `npm run delete_report` to delete report directory

Run a single spec file
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_e2e_hp.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_error_label_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_address_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_date_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_adults_and_children_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/Service/service_cookies_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_bedrooms_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_links_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_postcode_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_self_assesment_uhp.cy.js

Run with specific browser
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_e2e_hp.cy.js --browser chrome
