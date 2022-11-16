require('cypress-xpath')
const elements = require('../../page_elements/EOI/eoi_elements')



export const adults_and_children_nv = () => {
    cy.visit('/expression-of-interest/steps/10')
    cy.get(elements.coockies_accept).click().wait(1000)
    cy.get(elements.hide_coockie_msg).click().wait(1000)
    cy.get(elements.page_heading).contains('How many people normally live in the property you’re offering (not including guests)?').should('be.visible')
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.adults_error).should('exist')
    cy.get(elements.children_error).should('exist')
}
//one value filled
export const adults_and_children_v1 = () => {
    cy.get(elements.adults_textbox_error).clear().type(4)
    cy.get(elements.children_textbox_error).clear()
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.adults_error).should('not.exist')
    cy.get(elements.children_error).should('exist')
}
export const adults_and_children_v2 = () => {
    cy.get(elements.adults_textbox).clear()
    cy.get(elements.children_textbox_error).clear().type(2)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.adults_error).should('exist')
    cy.get(elements.children_error).should('not.exist')
}

//one value invalid
export const adults_and_children_v3 = () => {
    cy.get(elements.adults_textbox_error).clear().type(10)
    cy.get(elements.children_textbox).clear().type(9)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.adults_error).should('exist')
    cy.get(elements.children_error).should('not.exist')
}
export const adults_and_children_v4 = () => {
    cy.get(elements.adults_textbox_error).clear().type(9)
    cy.get(elements.children_textbox).clear().type(10)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.adults_error).should('not.exist')
    cy.get(elements.children_error).should('exist')
}

//adults value zero & children invalid
export const adults_and_children_v5 = () => {
    cy.get(elements.adults_textbox).clear().type(0)
    cy.get(elements.children_textbox_error).clear().type(20)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.one_adult_living_w_children_error).should('exist')
    cy.get(elements.children_error).should('exist')
}
//adults invalid & children zero
export const adults_and_children_v6 = () => {
    cy.get(elements.adults_textbox_error).clear().type(100)
    cy.get(elements.children_textbox_error).clear().type(0)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.adults_error).should('exist')
    cy.get(elements.children_error).should('not.exist')
}

//both fields invalid
export const adults_and_children_v7 = () => {
    cy.get(elements.adults_textbox_error).clear().type(1000)
    cy.get(elements.children_textbox).clear().type(2000)
    cy.get(elements.continue_button).click().wait(500)
    cy.get(elements.adults_error).should('exist')
    cy.get(elements.children_error).should('exist')
}

//both fields valid
export const adults_and_children_v8 = () => {
    cy.get(elements.adults_textbox_error).clear().type(6)
    cy.get(elements.children_textbox_error).clear().type(4)
    cy.get(elements.continue_button).click().wait(1000)
    cy.get(elements.children_error).should('not.exist')
    cy.get(elements.adults_error).should('not.exist').wait(500)
    cy.get(elements.page_heading).contains('Who would you like to offer accommodation to?')
}

