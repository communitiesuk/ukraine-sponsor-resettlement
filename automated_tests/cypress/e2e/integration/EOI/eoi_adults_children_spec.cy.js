const alfa = require('../../pages/EOI/eoi_adults_&_children')

describe('[Frontend-UI]: EOI ADULTS AND CHILDREN', function () {
  this.beforeAll(() => {
    cy.newSession()
  });

  context('Adults and Children', function () {
    it('adults and children [null values]', function () {
      alfa.adults_and_children_nv()
    })
    it('adults and children [one value field filled, A:4/C:Null]', function () {
      alfa.adults_and_children_v1()
    })
    it('adults and children [one value field filled, A:Null/C:2]', function () {
      alfa.adults_and_children_v2()
    })
    it('adults and children [one value field invalid, A:10/C:9]', function () {
      alfa.adults_and_children_v3()
    })
    it('adults and children [one value field invalid, A:9/C:10]', function () {
      alfa.adults_and_children_v4()
    })
    it('adults and children [adults value field zero, children value field invalid A:0/C:20]', function () {
      alfa.adults_and_children_v5()
    })
    it('adults and children [adults value field invalid, children value field zero A:100/C:0]', function () {
      alfa.adults_and_children_v6()
    })
    it('adults and children [both fields invalid A:1000/C:2000]', function () {
      alfa.adults_and_children_v7()
    })
    it('adults and children [both fields valid A:6/C:4]', function () {
      alfa.adults_and_children_v8()
    })
  })
})