const element = require('../../pages/EOI/eoi_date')

describe('[Frontend-UI]: EOI DATE VALIDATION', function () {
  this.beforeAll(() => {
    cy.clearCookie('_ukraine_sponsor_resettlement_session')
  });
  Cypress.Cookies.defaults({ preserve: '_ukraine_sponsor_resettlement_session' })

  context('Specific Date Validations', function () {
    it("date error validations [null values]", function () {
      element.date_null()
    })
    it("date error validations [one value filled 'dd/mm/yyyy']", function () {
      element.date_v1()
    })
    it("date error validations [two values filled 'dd/mm/yyyy']", function () {
      element.date_v2()
    })
    it("date error validations [invalid date, 31-02-2023]", function () {
      element.date_v3()
    })
    it("date error validations [before today's date, 01-10-2022]", function () {
      element.date_v4()
    })
    it("date error validations [invalid day, 35]", function () {
      element.date_v5()
    })
    it("date error validations [invalid month, 18]", function () {
      element.date_v6()
    })
    it("date error validations [invalid month, 500]", function () {
      element.date_v7()
    })
    it("date error validations [all valid, 31-12-2030]", function () {
      element.date_av()
    })
    it("date error validations [confirmation]", function () {
      element.no_of_people_living_page()
    })
    this.afterAll(() => {
      cy.clearCookie('_ukraine_sponsor_resettlement_session')
    });
  })
})