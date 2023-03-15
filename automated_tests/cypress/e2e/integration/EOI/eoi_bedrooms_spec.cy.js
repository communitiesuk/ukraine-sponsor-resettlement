const element = require('../../pages/EOI/eoi_bedrooms')

describe('[Frontend-UI]: EOI BEDROOM VALIDATION', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Bedroom Validation Errors', function () {
    it("bedroom error validation [Null Values]", function () {
      element.bedrooms_null()
    })
    it("bedroom error validation [Value: Single: 0 / Double: 0]", function () {
      element.bedrooms_v1()
    })
    it("bedroom error validation [Value: Single: 0 / Double: Null]", function () {
      element.bedrooms_v2()
    })
    it("bedroom error validation [Value: Single: Null / Double: 0]", function () {
      element.bedrooms_v3()
    })
    it("bedroom error validation [Value: Single: 5 / Double: Null]", function () {
      element.bedrooms_v4()
    })
    it("bedroom error validation [Value: Single: Null / Double: 8]", function () {
      element.bedrooms_v5()
    })
    it("bedroom error validation [Value: Single: 11 / Double: 15]", function () {
      element.bedrooms_v6()
    })
    it("bedroom error validation [Value: Single: 9 / Double: 11]", function () {
      element.bedrooms_v7()
    })
    it("bedroom error validation [Value: Single: 11 / Double: 9]", function () {
      element.bedrooms_v8()
    })
    it("bedroom error validation [Value: Single: 0 / Double: 9]", function () {
      element.bedrooms_v9()
    })
    it("bedroom error validation [Value: Single: 0 / Double: 9]", function () {
      element.bedrooms_v10()
    })
    this.afterAll(() => {
      cy.clearCookie('_ukraine_sponsor_resettlement_session')
    });
  })
})