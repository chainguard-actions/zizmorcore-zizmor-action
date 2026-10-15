<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.7.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.7.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: The env var `${GHA_ZIZMOR_INPUTS}` — populated from `inputs.inputs` (a workflow-controllable value via `GHA_ZIZMOR_INPUTS: ${{ inputs.inputs }}` in action.yml) — is expanded without double-quoting in the zizmor invocation in action.sh. The unquoted expansion `${GHA_ZIZMOR_INPUTS}` allows the shell to perform word-splitting and glob expansion on any metacharacters (`;`, `|`, `&`, `$(...)`, backticks, glob chars, etc.) present in the value. Although `--` prevents the value from being interpreted as flags, it does not prevent shell metacharacter processing. The offending line is: `    ${GHA_ZIZMOR_INPUTS} \`

Locations:

- `action.sh:122`
- `action.yml:89`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script injection vulnerability in action.sh at line 122. The unquoted `${GHA_ZIZMOR_INPUTS}` expansion (which allowed shell metacharacter injection via `;`, `|`, `&`, `$(...)`, backticks, etc.) was replaced with a safe xargs-based tokenization approach. The fix: (1) guards with `if [[ -n "${GHA_ZIZMOR_INPUTS}" ]]` to avoid empty-argument issues, (2) uses `printf '%s' "${GHA_ZIZMOR_INPUTS}" | xargs -r printf '%s\0'` for quote-aware tokenization without evaluating shell metacharacters, (3) reads NUL-delimited tokens into a bash array `zizmor_inputs`, and (4) expands the array with proper double-quoting `"${zizmor_inputs[@]}"`. This preserves the intended word-splitting behavior for whitespace-separated path inputs while preventing injection.

