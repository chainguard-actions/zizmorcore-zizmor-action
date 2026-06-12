<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.5.6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **zizmorcore--zizmor-action/v0.5.6** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: The env var `GHA_ZIZMOR_INPUTS` (sourced from `inputs.inputs`, which is user-controlled) is expanded **unquoted** in the `docker run` command in `action.sh`. Although it is placed after `--` to prevent flag injection, the unquoted shell expansion still allows an attacker to inject shell metacharacters (`;`, `|`, `&`, `$(...)`, backticks, glob characters, etc.) that are interpreted by the shell before the command runs. The offending line is: `${GHA_ZIZMOR_INPUTS} \` (the `# shellcheck disable=SC2086` comment confirms this is intentional but it remains a security risk). The fix is to use a proper array: parse `GHA_ZIZMOR_INPUTS` into an array with `read -ra` and expand it as `"${inputs_array[@]}"`.

Offending line: `    ${GHA_ZIZMOR_INPUTS} \`

Locations:

- `action.sh:97`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed the script injection vulnerability in action.sh at line 97. Replaced the unquoted `${GHA_ZIZMOR_INPUTS}` expansion with a safe array-based approach: added `read -ra inputs_array <<< "${GHA_ZIZMOR_INPUTS}"` to parse the user-controlled input into a bash array, then expanded it as `"${inputs_array[@]}"` in the docker run command. This ensures word-splitting happens safely without exposing shell metacharacters to shell interpretation. Also removed the `# shellcheck disable=SC2086` comment that was suppressing the warning about the unquoted variable.

