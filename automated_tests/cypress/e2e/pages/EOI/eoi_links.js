require('cypress-xpath')
const elements = require('../../page_elements/EOI/eoi_elements')

//header
export const links_validation_govuk = () => {
    cy.visit('/expression-of-interest/').wait(Cypress.env('waitTime'))
    cy.get(elements.cookies_accept).click().wait(Cypress.env('waitTime'))
    cy.get(elements.hide_cookie_msg).click().wait(Cypress.env('waitTime'))
}
export const validation_error = () => {
    cy.writeFile('cypress/fixtures/envlinks.txt', '') //clear the text file
    cy.writeFile('cypress/fixtures/envlinks.txt', { alfa: 'url changed' })
    cy.log('[************* FAILED TEST *************]()')
    cy.log('************* **FAILED TEST** *************')
    cy.log('[************* FAILED TEST *************]()')
    cy.log('************* **FAILED TEST** *************')
    cy.log('[************* FAILED TEST *************]()')
    cy.log('************* **FAILED TEST** *************')
    cy.log('[*** FAILED TEST *** DUE TO ENVIRONMENT (local/staging/prod) URL CHANGED, ENTER THE CORRECT URL AND RE-RUN THE TEST > >> >>> >>>> >>>>>** ***]()')
    //cy.readFile('cypress/fixtures/envlinks.txt').should('not.contains', 'url changed')
    cy.writeFile('cypress/fixtures/envlinks.txt', '') //clear the text file
}
export const links_validation_hfu = () => {
    cy.visit('/expression-of-interest/self-assessment/challenges').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains("Important things to consider").should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.huf_header_link).click().wait(Cypress.env('waitTime'))

    let local = ('http://localhost:8080');
    let staging = ('https://ukraine-sponsor-resettlement-staging.london.cloudapps.digital/')
    let prod = ('https://apply-to-offer-homes-for-ukraine.service.gov.uk/')

    //get the current url and save it in a file
    cy.url().then(envurl => {
        const saveLocation = `cypress/fixtures/envlinks.txt`
        cy.writeFile(saveLocation, { envurl }).wait(Cypress.env('waitTime'))
    })
    //get the url from the saved location and save it as a variable
    cy.readFile(`cypress/fixtures/envlinks.txt`).then((saved_url) => {
        //localhost
        if (saved_url.includes(local)) {
            cy.url().should('include', Cypress.config('baseUrl')).should('exist')
            cy.log("[This is LOCALHOST / homes-for-ukraine URL]()")
            cy.writeFile('cypress/fixtures/envlinks.txt', '') //clear the text file
            return
        }
        //staging
        else if (saved_url.includes(staging)) {
            cy.url().should("have.contain", 'london.cloudapps.digital')
            cy.log("[This is STAGING / homes-for-ukraine URL]()")
            cy.writeFile('cypress/fixtures/envlinks.txt', '') //clear the text file
            return
        }
        //prod
        else if (saved_url.includes(prod)) {
            cy.url().should('include', Cypress.config('baseUrl')).should('exist')
            cy.log("[This is PROD / homes-for-ukraine URL]()")
            cy.writeFile('cypress/fixtures/envlinks.txt', '') //clear the text file
            return
        }
        else {
            validation_error()
        }
    })
}
//footer
export const links_validation_govlicence = () => {
    cy.visit('/expression-of-interest/').wait(Cypress.env('waitTime'))
    cy.get(elements.gov_licence_link).click().wait(Cypress.env('waitTime'))
    cy.url().should('include', 'https://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/').should('exist')
    cy.get(elements.gov_licence_logo).should('be.visible').wait(Cypress.env('waitTime'))
}
export const links_validation_crown_copyright = () => {
    cy.visit('/expression-of-interest/').wait(Cypress.env('waitTime'))
    cy.get(elements.crown_copyright_link).click().wait(Cypress.env('waitTime'))
    cy.url().should('include', 'https://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/')
    cy.get(elements.crown_copyright_header).contains("Crown copyright").wait(Cypress.env('waitTime'))
}

//self assesment
export const links_validation_sa_other_ways_l1 = () => {
    cy.visit('/expression-of-interest/self-assessment/other-ways-to-help').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains("There are other ways you can help").should('be.visible').wait(Cypress.env('waitTime'))
    cy.xpath(elements.local_council_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', 'https://www.gov.uk/find-local-council')
    cy.get(elements.main_heading_xl).contains("Find your local council").should('be.visible').wait(Cypress.env('waitTime'))
    cy.go('back')
}
export const links_validation_sa_other_ways_l2 = () => {
    cy.visit('/expression-of-interest/self-assessment/other-ways-to-help').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains("There are other ways you can help").should('be.visible').wait(Cypress.env('waitTime'))
    cy.xpath(elements.stand_with_ukraine_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', 'https://www.gov.uk/government/news/ukraine-what-you-can-do-to-help')
    cy.get(elements.main_heading).contains("Ukraine: what you can do to help").should('be.visible').wait(Cypress.env('waitTime'))
    cy.go('back')
}
export const links_validation_sa_other_ways_l3 = () => {
    cy.visit('/expression-of-interest/self-assessment/other-ways-to-help').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains("There are other ways you can help").should('be.visible').wait(Cypress.env('waitTime'))
    cy.xpath(elements.community_sponsorship_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', 'https://www.gov.uk/government/publications/apply-for-full-community-sponsorship')
    cy.get(elements.main_heading).contains("Apply for community sponsorship").should('be.visible').wait(Cypress.env('waitTime'))
    cy.go('back')
}
export const links_validation_sa_other_ways_l4 = () => {
    cy.visit('/expression-of-interest/self-assessment/other-ways-to-help').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains("There are other ways you can help").should('be.visible').wait(Cypress.env('waitTime'))
    cy.xpath(elements.volunteering_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', 'volunteer')
    cy.get(elements.main_heading_xl).contains("Volunteer").should('be.visible').wait(Cypress.env('waitTime'))
    cy.go('back')
}
export const links_validation_sa_other_ways_l5 = () => {
    cy.visit('/expression-of-interest/self-assessment/other-ways-to-help').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains("There are other ways you can help").should('be.visible').wait(Cypress.env('waitTime'))
    cy.xpath(elements.support_organisations_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', 'https://www.gov.uk/guidance/find-a-sponsor-using-recognised-providers-homes-for-ukraine')
    cy.get(elements.main_heading).contains("Find a sponsor using recognised providers: Homes for Ukraine").should('be.visible').wait(Cypress.env('waitTime'))
    cy.go('back')
}
export const links_validation_postcode_check_page_l1 = () => {
    cy.visit('/expression-of-interest/steps/end').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('You have entered an address that is not in England or Northern Ireland').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.scotland_link).click().wait(Cypress.env('waitTime'))
    cy.url().should('include', 'https://www.mygov.scot/homes-for-ukraine-scotland-super-sponsor-scheme')
    cy.get(elements.page_heading_scotland).contains("How the Homes for Ukraine Super Sponsor Scheme works").should('be.visible').wait(Cypress.env('waitTime'))
    cy.go('back')
}
export const links_validation_postcode_check_page_l2 = () => {
    cy.visit('/expression-of-interest/steps/end').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('You have entered an address that is not in England or Northern Ireland').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.wales_link).click().wait(Cypress.env('waitTime'))
    cy.url().should('include', 'https://www.gov.wales/offer-home-wales-refugees-ukraine')
    cy.get(elements.page_heading_wales).contains("Offer a home in Wales to refugees from Ukraine").should('be.visible').wait(Cypress.env('waitTime'))
    cy.go('back')
}
export const links_validation_postcode_check_page_l3 = () => {
    cy.visit('/expression-of-interest/steps/end').wait(Cypress.env('waitTime'))
    cy.get(elements.page_heading).contains('You have entered an address that is not in England or Northern Ireland').should('be.visible').wait(Cypress.env('waitTime'))
    cy.xpath(elements.local_council_link_samepage).click().wait(Cypress.env('waitTime'))
    cy.url().should('include', 'https://www.gov.uk/find-local-council')
    cy.get(elements.main_heading_xl).contains("Find your local council").should('be.visible').wait(Cypress.env('waitTime'))
    cy.go('back')
}
export const links_validation_step_16 = () => {
    cy.visit('/expression-of-interest/steps/16').wait(Cypress.env('waitTime'))
    cy.get(elements.consent_heading).contains('Confirm you have read the privacy statement').should('be.visible').wait(Cypress.env('waitTime'))
    cy.get(elements.privacy_statement_link).invoke('removeAttr', 'target').click().wait(Cypress.env('waitTime'))
    cy.url().should('include', 'https://www.gov.uk/guidance/homes-for-ukraine-visa-sponsorship-scheme-privacy-notice')
    cy.get(elements.main_heading).contains("Homes for Ukraine visa sponsorship scheme: privacy notice").should('be.visible').wait(Cypress.env('waitTime'))
    cy.go('back')
}
