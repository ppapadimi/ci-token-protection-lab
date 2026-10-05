// Benign default: confirms the token reached the action, prints nothing derived from it.
const t = process.env.INPUT_PROJECTTOKEN || ''
console.log('[secret-consumer] action ran; projectToken present=' + (t.length > 0))
