<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.6.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.6.4** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: In action.sh, the shell variable `${GHA_ZIZMOR_INPUTS}` is intentionally left unquoted in the `docker run` command (accompanied by a `# shellcheck disable=SC2086` comment). This variable is populated from `inputs.inputs` — a user-controlled composite action input — via `env: GHA_ZIZMOR_INPUTS: ${{ inputs.inputs }}` in action.yml. While placing it after `--` prevents flag injection, the unquoted expansion still allows the shell to perform word-splitting and glob expansion on attacker-controlled data. The correct safe form would be to use `eval` with proper quoting, `xargs`, or the guarded `${GHA_ZIZMOR_INPUTS:+"$GHA_ZIZMOR_INPUTS"}` pattern. Offending line: `    ${GHA_ZIZMOR_INPUTS} \`

Locations:

- `action.sh:97`
- `action.yml:86`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed the script-injection vulnerability in action.sh at line 97. The unquoted `${GHA_ZIZMOR_INPUTS}` expansion (which allowed glob expansion and other shell manipulation on attacker-controlled data from `inputs.inputs`) was replaced with a safe xargs-based tokenization into a bash array. The fix uses `printf '%s' "${GHA_ZIZMOR_INPUTS}" | xargs printf '%s\0'` piped through a NUL-delimited read loop to populate a `zizmor_inputs` array, which is then expanded as `"${zizmor_inputs[@]}"` in the docker run command. This preserves the intended quote-aware word-splitting behavior while preventing glob expansion and shell injection. The `# shellcheck disable=SC2086` comment was also removed as it is no longer needed.

