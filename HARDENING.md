<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.6.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.6.3** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: In action.sh, the env var `${GHA_ZIZMOR_INPUTS}` — which holds the value of `inputs.inputs` (a user-controlled composite action input, mapped via `GHA_ZIZMOR_INPUTS: ${{ inputs.inputs }}` in action.yml) — is intentionally expanded **unquoted** in the `docker run` command: `${GHA_ZIZMOR_INPUTS} \`. An attacker who controls the `inputs` input can inject shell metacharacters (`;`, `|`, `&`, `$(...)`, backticks, glob chars, etc.) that the shell will interpret before Docker ever sees them, enabling arbitrary command execution on the runner. The comment in the script acknowledges the unquoted expansion is intentional for word-splitting, but this does not mitigate the injection risk from untrusted input.

Locations:

- `action.sh:89`
- `action.yml:96`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed the script injection vulnerability in action.sh at line 89. The unquoted `${GHA_ZIZMOR_INPUTS}` expansion was replaced with a safe xargs-based tokenization approach: the input is tokenized via `printf '%s' "${GHA_ZIZMOR_INPUTS}" | xargs printf '%s\0'` into a bash array `zizmor_inputs`, guarded by a `[ -n ... ]` check to avoid empty-token issues. The array is then expanded as `"${zizmor_inputs[@]}"` in the docker run command. This preserves the intended whitespace-splitting behavior while preventing shell metacharacter injection (`;`, `|`, `&`, `$(...)`, backticks, globs, etc.) from user-controlled input.

