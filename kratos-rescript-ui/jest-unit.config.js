module.exports = {
  testEnvironment: "jsdom",
  testMatch: [
    "**/__tests__/**/*.mjs",
  ],
  verbose: true,
  transform: {
    "\\.m?[jt]sx?$": "babel-jest"
  },
  transformIgnorePatterns: [
    "/node_modules/(?!@glennsl/bs-jest|bs-platform).+\\.js$",
    "/node_modules/rescript/.*",
  ],
  moduleFileExtensions: [
    "js",
    "json",
    "jsx",
    "node",
    "mjs"
  ],
}
