<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.5.7

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **zizmorcore--zizmor-action/v0.5.7** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (b): In action.sh, the env var `${GHA_ZIZMOR_INPUTS}` (sourced from `inputs.inputs`, a user-controlled value) is used unquoted at line 105 in the `docker run` command: `    ${GHA_ZIZMOR_INPUTS} \`. Although it is placed after `--` to prevent flag injection, the bash shell still performs word-splitting and glob-expansion on the unquoted value before passing arguments to docker. Shell metacharacters such as `$(...)`, backticks, `;`, `|`, and `&` embedded in the input value would be interpreted by bash, enabling command injection. The value should be passed via a properly quoted array element or sanitized before use.

Locations:

- `action.sh:105`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed the script injection vulnerability in action.sh at line 105. The unquoted `${GHA_ZIZMOR_INPUTS}` expansion (which allowed shell metacharacter injection via word-splitting and glob expansion) was replaced with a safe two-step approach: (1) `read -ra zizmor_inputs <<< "${GHA_ZIZMOR_INPUTS}"` to safely parse the whitespace-separated input into a bash array, and (2) `"${zizmor_inputs[@]}"` to expand the array with proper quoting in the docker run command. This preserves the intended word-splitting behavior while preventing shell metacharacters from being interpreted as commands. The `# shellcheck disable=SC2086` comment was also removed as it is no longer needed.

