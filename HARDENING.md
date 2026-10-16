<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.7.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.7.1** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (b): In action.sh, the variable ${GHA_ZIZMOR_INPUTS} — which holds the workflow-controllable value of inputs.inputs (set via `env: GHA_ZIZMOR_INPUTS: ${{ inputs.inputs }}` in action.yml) — is used **unquoted** in the shell command that invokes zizmor: `${GHA_ZIZMOR_INPUTS}` on the command line. While `--` prevents flag injection, the unquoted expansion still allows the shell to interpret metacharacters (glob patterns, `$(...)` command substitution, backticks, etc.) present in the attacker-controlled value before passing it as arguments. The offending line is: `${GHA_ZIZMOR_INPUTS} \` (with a `# shellcheck disable=SC2086` suppressing the warning).

Locations:

- `action.sh:97`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed the script-injection vulnerability in action.sh at line 97. The unquoted `${GHA_ZIZMOR_INPUTS}` expansion (which allowed shell metacharacter interpretation including globs, command substitution, and backticks) was replaced with a safe xargs-based tokenization approach. The value is now tokenized using `printf '%s' "${GHA_ZIZMOR_INPUTS}" | xargs -r printf '%s\0'` into a bash array `zizmor_inputs`, then expanded as `"${zizmor_inputs[@]}"` (properly quoted). This preserves the intended word-splitting behavior for the whitespace-separated list of inputs while preventing metacharacter injection. The guard `if [[ -n "${GHA_ZIZMOR_INPUTS}" ]]` prevents xargs from emitting an empty token when the input is empty.

