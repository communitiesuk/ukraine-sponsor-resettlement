const alfa = require('../../pages/EOI/address_validation')

describe('[Frontend-UI]: EOI FORM ADDRESS VALIDATION', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Residential Address', function () {
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

  this.afterAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
})






