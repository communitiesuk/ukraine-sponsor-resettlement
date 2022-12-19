const { defineConfig } = require('cypress');

module.exports = defineConfig({
  chromeWebSecurity: false,
  video: false,
  videoUploadOnPasses: true,
  videoCompression: false,
  viewportWidth: 1000,
  viewportHeight: 1500,
  reporter: 'cypress-mochawesome-reporter',
  reporterOptions: {
    charts: true,
    reportPageTitle: 'custom-title',
    embeddedScreenshots: true,
    inlineAssets: true,
    saveAllAttempts: false,
  },
  
  e2e: {
    setupNodeEvents(on, config) {
      require('cypress-mochawesome-reporter/plugin')(on);
      require('cypress-high-resolution')(on, config)
    },
    
  baseUrl: 'http://localhost:8080', // if you change this on your machine, do not commit!!!
  excludeSpecPattern: process.env.all ? ['cypress/e2e/integration/EOI/run_all_specs.cy.js'] : [],
  },
  env: {
    waitTime: 150, // if you change this on your machine, do not commit!!!
  }
});