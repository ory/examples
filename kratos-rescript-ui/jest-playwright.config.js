const recordingEnabled = process.env.PW_RECORD === "ENABLED"
const recordingOpts = {
  launchType: "LAUNCH",
  contextOptions: {
    recordVideo: {
      dir: 'videos/',
    },
  },
}

module.exports = {
  ...(recordingEnabled ? recordingOpts : {}),
  browsers: ["chromium"],
  launchOptions: {
    headless: true,
  },
  contextOptions: {
    recordVideo: {
      dir: 'videos/'
    },
  },
}
