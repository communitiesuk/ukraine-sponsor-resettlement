require('cypress-xpath')
const elements = require('../../page_elements/Service/service_elements')


export const eoi_cookies_page_back_link = () => {
  // Visit a page
  cy.visit('/sponsor-a-child/').wait(250)
  // Visit the cookies page through the banner links
  cy.get(elements.cookies_page_link_from_banner).should('be.visible')
  cy.get(elements.cookies_page_link_from_banner).click().wait(250)
  // Select some cookies settings (either yes or no) and click submit
  // Verify that back_to link == '/sponsor-a-child
  cy.get(elements.cookies_accept_cookies_page).click().wait(250)
  cy.get('form').submit().wait(250)
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
  cy.contains(elements.view_cookies).click().wait(250)
  cy.get(elements.cookie_banner_heading).should('not.exist')
}

export const banner_hidden_after_clicking_goback_to_page_link = () => {
  cy.visit('/expression-of-interest/steps/9')
  cy.contains(elements.view_cookies).click().wait(250)
  cy.get(elements.cookie_page_yes_input).click()
  cy.contains(elements.save_cookie_settings).click().wait(250)
  cy.contains(elements.go_back_to_previous_page).click().wait(250)
  cy.get(elements.cookie_banner_heading).should('not.exist')
  cy.contains(elements.hide_cookie_message).should('not.exist')

}

