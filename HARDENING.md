<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.5.7

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.5.7** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: The env var `GHA_ZIZMOR_INPUTS` (sourced from `${{ inputs.inputs }}`, a user-controlled value) is expanded **unquoted** as `${GHA_ZIZMOR_INPUTS}` in the `docker run` command in `action.sh`. While the value is placed after `--` to prevent flag injection, the unquoted expansion still subjects the value to shell word-splitting and glob expansion on attacker-controlled content. The fix is to either double-quote the expansion (`"${GHA_ZIZMOR_INPUTS}"`) or use `eval` with proper quoting if word-splitting is intentionally desired.

Locations:

- `action.sh:93`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed unquoted `${GHA_ZIZMOR_INPUTS}` expansion in action.sh (line 93). Replaced the unquoted expansion (which was subject to glob expansion on attacker-controlled content) with a safe xargs-based tokenization approach: the input is tokenized into a bash array using `printf '%s' "${GHA_ZIZMOR_INPUTS}" | xargs printf '%s\0'` with a NUL-delimited read loop, then expanded as `"${inputs[@]}"`. This preserves the intended word-splitting behavior (the `inputs` input is documented as a whitespace-separated list) while preventing glob expansion. The guard `if [[ -n "${GHA_ZIZMOR_INPUTS}" ]]` ensures xargs is not run on empty input, which would otherwise produce a spurious empty token. The `# shellcheck disable=SC2086` comment was also removed since it is no longer needed.

