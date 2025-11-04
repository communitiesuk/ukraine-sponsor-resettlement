const element = require('../../pages/EOI/eoi_links')

describe('[Frontend-UI]: EOI PAGE LINKS', function () {
  this.beforeEach(() => {
    cy.newSession()
  })

  context('Header', function () {
    it('Page links validation [Header: Gov.UK]', function () {
      element.links_validation_govuk()
    })
    it('Page links validation [Header: Homes for Ukraine]', function () {
      element.links_validation_hfu()
    })
  })
  context('Footer', function () {
    it('Page links validation [Footer: Government Licence]', function () {
      element.links_validation_govlicence()
    })
    it('Page links validation [Footer: Crown Copyright]', function () {
      element.links_validation_crown_copyright()
    })
  })
  context('Self Assessment', function () {
    it('Page links validation [Other ways you can help page: local council]', function () {
      element.links_validation_sa_other_ways_l1()
    })
    it('Page links validation [Other ways you can help page: stand with ukraine]', function () {
      element.links_validation_sa_other_ways_l2()
    })
    it('Page links validation [Other ways you can help page: community sponsorship]', function () {
      element.links_validation_sa_other_ways_l3()
    })
    it('Page links validation [Other ways you can help page: volunteer]', function () {
      element.links_validation_sa_other_ways_l4()
    })
    it('Page links validation [Other ways you can help page: support these organisations]', function () {
      element.links_validation_sa_other_ways_l5()
    })
  })
  context('Registration', function () {
    it('Page links validation [Postcode verification page: Register your interest in Scotland]', function () {
      element.links_validation_postcode_check_page_l1()
    })
    it('Page links validation [Postcode verification page: Register your interest in Wales]', function () {
      element.links_validation_postcode_check_page_l2()
    })
    it('Page links validation [Postcode verification page: Find the local council]', function () {
      element.links_validation_postcode_check_page_l3()
    })
    it('Page links validation [steps 16: privacy statement]', function () {
      element.links_validation_step_16()
    })
  })
})
