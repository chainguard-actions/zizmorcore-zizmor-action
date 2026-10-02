<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.6.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.6.4** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (b) violation: `${GHA_ZIZMOR_INPUTS}` is expanded unquoted inside the `docker run` shell command in action.sh. This env var is sourced from `${{ inputs.inputs }}` (user-controlled). Although it is placed after `--` to prevent flag injection, the unquoted shell expansion still allows the shell to interpret metacharacters (e.g., `$(...)`, backticks, semicolons, glob characters) embedded in the value before passing arguments to docker. The offending line is: `    ${GHA_ZIZMOR_INPUTS} \`

Locations:

- `action.sh:117`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed the unquoted `${GHA_ZIZMOR_INPUTS}` expansion in action.sh (line 117). Replaced the unquoted shell expansion (which allowed metacharacter injection) with a safe xargs-based tokenization into a bash array. The `GHA_ZIZMOR_INPUTS` value (sourced from `inputs.inputs`) is now tokenized via `printf '%s' "${GHA_ZIZMOR_INPUTS}" | xargs printf '%s\0'` into a `zizmor_inputs` array, which is then expanded as `"${zizmor_inputs[@]}"`. This preserves the intended word-splitting behavior (honoring quotes in the input) while preventing shell metacharacter injection. A guard `[[ -n "${GHA_ZIZMOR_INPUTS}" ]]` prevents xargs from emitting a spurious empty argument when the input is empty.

