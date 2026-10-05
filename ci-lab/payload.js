// Would be preloaded by `node --require` if NODE_OPTIONS could be injected.
const fs = require('fs')
fs.appendFileSync(process.env.GITHUB_STEP_SUMMARY || '/dev/null',
  '### [payload.js] NODE_OPTIONS preload executed\n')
console.log('[payload.js] NODE_OPTIONS preload executed')
