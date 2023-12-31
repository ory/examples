const nextJest = require("next/jest");

const createJestConfig = nextJest({
  dir: "./"
});

const customJestConfig = {
  moduleNameMapper: {
    '^@/lib/(.*)$': '<rootDir>/lib/$1',
    '^@/pages/(.*)$': '<rootDir>/pages/$1'
  },
  testEnvironment: "jest-environment-jsdom"
};

module.exports = createJestConfig(customJestConfig);
