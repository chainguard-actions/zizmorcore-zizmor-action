<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.5.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.5.2** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: The env var `GHA_ZIZMOR_INPUTS` (sourced from `${{ inputs.inputs }}`, a user-controlled input) is expanded **unquoted** in the `docker run` command in `action.sh`. The script intentionally omits quotes to allow shell word-splitting, as noted by the comment and `# shellcheck disable=SC2086`. An attacker can supply shell metacharacters (`;`, `|`, `&`, `$(...)`, glob characters, etc.) in the `inputs` action input, which the shell will interpret before Docker ever sees them — enabling command injection. The offending line is: `    ${GHA_ZIZMOR_INPUTS} \`

Locations:

- `action.sh:101`
- `action.yml:87`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script injection vulnerability in action.sh at line 101. The original code expanded `${GHA_ZIZMOR_INPUTS}` unquoted in the `docker run` command, allowing shell metacharacters from the user-controlled `inputs` action input to be interpreted by the shell. Replaced the unquoted expansion with xargs-based quote-aware tokenization: the input is piped through `printf '%s' "$VAR" | xargs printf '%s\0'` into a `while IFS= read -r -d '' t` loop that populates a `zizmor_inputs` bash array. The array is then passed fully quoted (`"${zizmor_inputs[@]}"`) to `docker run`. This preserves the intended word-splitting behavior (honoring single/double quotes and backslashes) while preventing injection of shell metacharacters (`;`, `|`, `&`, `$(...)`, etc.). The required `if [[ -n ... ]]` guard prevents xargs from emitting an empty token when the input is empty.

