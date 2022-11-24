const elements = require('../../page_elements/EOI/eoi_elements')
const error = require('../../../fixtures/bodytext_error.json')

export const cookieDisplays = () => {
    cy.visit('/expression-of-interest/steps/9')
    cy.get(elements.cookie_banner_heading).should('exist')
}

export const cookieMessageDissapearsOnClickingViewCookies = () => {
    cy.visit('/expression-of-interest/steps/9')
    cy.contains('View cookies').click().wait(250)
    cy.get(elements.cookie_banner_heading).should('not.exist')
}

export const bannerHiddenOnReturningToPageYouWereLookingAt = () => {
    cy.visit('/expression-of-interest/steps/9')
    cy.contains('View cookies').click().wait(250)
    cy.get(elements.cookie_page_yes_input).click()
    cy.contains(elements.save_cookie_settings).click().wait(250)
    cy.contains(elements.go_back_to_previous_page).click().wait(250)
    cy.get(elements.cookie_banner_heading).should('not.exist')

}

