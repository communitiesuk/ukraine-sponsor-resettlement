## Cypress-framework: UI testing

## Pre requisites
- You need to have npm installed to be able to run the tests on your local

## Usage
Install npm & cypress dependencies
- cd `automated tests` directory
- run `npm install` (install specific ver. `npm install cypress@10.9.0`)
- run `npm run cy_verify` to verify cypress installation (ver. should be: "^10.9.0")

## Before beginning the test:
If testing staging or a non-local env, create a .env in this directory and add BASE_URL="" of the desired url. 
Note: for staging
Add email & phone/mobile number here : 
- EOI : `../../automated_tests/cypress/fixtures/eoi_bodytext_secrets.json` 
- UAM : `../../automated_tests/cypress/fixtures/uam_appdata.json`

## Test Runner
- run `npm run cy_open` to open cypress test runnner
- select & run test(s)
- select `run_all_specs` to run all tests

## Command line
- run `all=specs npm run e2e` to run all tests using default Electron broswer and open the report
- run `npm run view_report` to view report on browser
- run `npm run headless` to run all tests headless mode
- run `npm run delete_report` to delete report directory

## Run a single spec file
# EOI:
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_e2e_hp_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_address_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_adults_children_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_backlink_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_bedrooms_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_date_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_error_label_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_legacy_journey_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_links_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_phone_number_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_postcode_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_self_assessment_uhp_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/Service/service_cookies_spec.cy.js
# `run all EOI specs`
- `npx cypress run --spec cypress/e2e/integration/EOI/run_all_eoi_specs.cy.js`

# UAM: 
- npx cypress run --spec cypress/e2e/integration/UAM/uam_e2e_hp_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/UAM/uam_eli_uhp_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/UAM/uam_links_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/UAM/uam_childs_accomm_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/UAM/uam_childs_details_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/UAM/uam_labels_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/UAM/uam_res_details_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/UAM/uam_your_details_spec.cy.js
# `run all UAM specs`
- `npx cypress run --spec cypress/e2e/integration/UAM/run_all_uam_specs.cy.js`   

## Run with specific browser
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_e2e_hp.cy.js --browser chrome

## Automation regression pack			
`https://docs.google.com/spreadsheets/d/1CS-Tfx93y1AGcTiwwCIICH4T2sLGrEl3q8RllyhLpPE/edit?pli=1#gid=0`