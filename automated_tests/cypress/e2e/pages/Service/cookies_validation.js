require('cypress-xpath')
const elements = require('../../page_elements/Service/service_elements')


export const eoi_cookies_page_back_link = () => {
  // Visit a page
  cy.visit('/sponsor-a-child/').wait(Cypress.env('waitTime'))
  // Visit the cookies page through the banner links
  cy.get(elements.cookies_page_link_from_banner).should('be.visible')
  cy.get(elements.cookies_page_link_from_banner).click().wait(Cypress.env('waitTime'))
  // Select some cookies settings (either yes or no) and click submit
  // Verify that back_to link == '/sponsor-a-child
  cy.get(elements.cookies_accept_cookies_page).click().wait(Cypress.env('waitTime'))
  cy.get('form').submit().wait(Cypress.env('waitTime'))
  // Verify that back_to link == '/sponsor-a-child
  cy.get(elements.cookies_back_to_cookies_page)
    .should('be.visible')
    .should('have.attr', 'href')
    .and('contain', 'sponsor-a-child')
}

export const cookie_displays = () => {
  cy.visit('/expression-of-interest/steps/9')
  cy.get(elements.cookie_banner_heading).should('exist')
}

export const cookie_message_dissappears_after_clicking_view_cookies = () => {
  cy.visit('/expression-of-interest/steps/9')
  cy.get(elements.view_cookies).click().wait(Cypress.env('waitTime'))
  cy.get(elements.cookie_banner_heading).should('not.exist')
}

export const banner_hidden_after_clicking_goback_to_page_link = () => {
  cy.visit('/expression-of-interest/steps/9')
  cy.get(elements.view_cookies).click().wait(Cypress.env('waitTime'))
  cy.get(elements.cookie_page_yes_input).click()
  cy.contains(elements.save_cookie_settings).click().wait(Cypress.env('waitTime'))
  cy.contains(elements.go_back_to_previous_page).click().wait(Cypress.env('waitTime'))
  cy.get(elements.cookie_banner_heading).should('not.exist')
  cy.contains(elements.hide_cookie_message).should('not.exist')
}

