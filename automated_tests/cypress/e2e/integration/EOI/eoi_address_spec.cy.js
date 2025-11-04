const alfa = require('../../pages/EOI/eoi_address')

describe('[Frontend-UI]: EOI ADDRESS', function () {
  this.beforeEach(() => {
    cy.newSession()
  })

  context('Residential Address', function () {
    this.beforeEach(() => {
      cy.visit('/expression-of-interest/steps/4').wait(Cypress.env('waitTime'))
    })
    
    it('residential address error validation [null values]', function () {
      alfa.residential_address_nv()
    })
    it('residential address error validation [single character]', function () {
      alfa.residential_address_sc()
    })
    it('residential address error validation [two characters]', function () {
      alfa.residential_address_tc()
    })
    it('residential address error validation [one text field valid]', function () {
      alfa.residential_address_v1()
    })
    it('residential address error validation [two text fields valid]', function () {
      alfa.residential_address_v2()
    })
    it('residential address error validation [all text fields valid]', function () {
      alfa.residential_address_av()
    })
  })

  context('Offering Property Address', function () {
    this.beforeEach(() => {
      cy.visit('/expression-of-interest/steps/6').wait(Cypress.env('waitTime'))
    })

    it('address of the property offering error validation [null values]', function () {
      alfa.offering_property_address_nv()
    })
    it('address of the property offering error validation [single character]', function () {
      alfa.offering_property_address_sc()
    })
    it('address of the property offering error validation [two characters]', function () {
      alfa.offering_property_address_tc()
    })
    it('address of the property offering error validation [one text field valid]', function () {
      alfa.offering_property_address_v1()
    })
    it('address of the property offering error validation [two text fields valid]', function () {
      alfa.offering_property_address_v2()
    })
    it('address of the property offering error validation [all text fields valid]', function () {
      alfa.offering_property_address_av()
    })
  })
})