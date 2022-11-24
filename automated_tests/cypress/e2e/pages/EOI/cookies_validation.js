require('cypress-xpath')
const elements = require('../../page_elements/EOI/eoi_elements')


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
