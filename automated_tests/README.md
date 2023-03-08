## Cypress-framework: UI testing

## Pre requisites
You need to have npm installed to be able to run the tests on your local

## Usage
Install npm & cypress dependencies
- cd `automated tests` directory
- run `npm install` (install specific ver. `npm install cypress@10.9.0`)
- run `npm run cy_verify` to verify cypress installation (ver. should be: "^10.9.0")

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
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_e2e_hp.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_address_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_adults_and_children_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_back_link_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_bedrooms_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_date_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_error_label_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_legacy_journey_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_links_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_phone_number_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_postcode_validation.cy.js
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_self_assesment_uhp.cy.js
- npx cypress run --spec cypress/e2e/integration/Service/service_cookies_validation.cy.js
# `run all EOI specs`
- `npx cypress run --spec cypress/e2e/integration/EOI/run_all_eoi_specs.cy.js`

# UAM: 
- npx cypress run --spec cypress/e2e/integration/UAM/uam_e2e_hp_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/UAM/uam_eli_uhp_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/UAM/uam_links_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/UAM/uam_val_err_childs_accomm_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/UAM/uam_val_err_childs_details_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/UAM/uam_val_err_labels_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/UAM/uam_val_err_res_details_spec.cy.js
- npx cypress run --spec cypress/e2e/integration/UAM/uam_val_err_your_details_spec.cy.js
# `run all UAM specs`
- `npx cypress run --spec cypress/e2e/integration/UAM/run_all_uam_specs.cy.js`   

## Run with specific browser
- npx cypress run --spec cypress/e2e/integration/EOI/eoi_e2e_hp.cy.js --browser chrome

## UAM Automation regression pack					
`https://docs.google.com/spreadsheets/d/1CS-Tfx93y1AGcTiwwCIICH4T2sLGrEl3q8RllyhLpPE/edit?pli=1#gid=0`