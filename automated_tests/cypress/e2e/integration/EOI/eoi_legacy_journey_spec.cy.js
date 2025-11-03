const elements = require("../../page_elements/EOI/eoi_elements");
const bodytext = require("../../../fixtures/eoi_bodytext.json");

const assertOnLandingPage = () => {
    cy.get(elements.page_heading).contains('Check if your property is suitable for hosting').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.second_header).contains(bodytext.home_is_suitable).should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).should('not.include.text', "How many people normally live in the property you’re offering (not including guests)?").wait(Cypress.env('waitTime'))
}

//Any URL within the individual or organisation routes should redirect the user to "/expression-of-interest/self-assessment/property-suitable" (old routes still existing on the DOM)
describe('[Frontend-UI]: EOI LEGACY JOURNEY REDIRECT', function () {
  this.beforeAll(() => {
    cy.newSession()
  })

  context('Legacy individual pages redirect to start', function () {
      for (let step = 1; step <= 17; step++) {
          it(`Step ${step} redirects to start`, function () {
              cy.visit(`/individual/steps/${step}`)
              assertOnLandingPage()
          })
      }
  })

  context('Legacy organisation pages redirect to start', function () {
      for (let step = 1; step <= 17; step++) {
          it(`Step ${step} redirects to start`, function () {
              cy.visit(`/organisation/steps/${step}`)
              assertOnLandingPage()
          })
      }
  })

  context('Legacy additional information pages redirect to start', function () {
      for (let step = 1; step <= 11; step++) {
          it(`Step ${step} redirects to start`, function () {
              cy.visit(`/additional-info/steps/${step}`)
              assertOnLandingPage()
          })
      }

      it(`Check answers redirects to start`, function () {
          cy.visit('/additional-info/steps/check-answers')
          assertOnLandingPage()
      })
  })
})