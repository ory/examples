const { defineConfig } = require('cypress');

module.exports = defineConfig({
  screenshotOnRunFailure: false,
  video: false,
  e2e: {
    baseUrl: 'http://localhost:3000',
    supportFile: false
  }
});
