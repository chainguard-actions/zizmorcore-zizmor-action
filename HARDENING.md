<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.5.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.5.3** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: The shell variable `${GHA_ZIZMOR_INPUTS}` — sourced from `inputs.inputs`, a user-controlled value — is intentionally left unquoted in the `docker run` command in `action.sh`. While the value is placed after `--` to prevent flag injection, the unquoted expansion still allows the shell to interpret metacharacters (e.g., `$(...)`, backticks, `;`, `|`, `&`) before passing arguments to `docker run`. The offending line is: `    ${GHA_ZIZMOR_INPUTS} \`. This should be quoted or sanitized to prevent shell metacharacter injection.

Locations:

- `action.sh:87`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script injection vulnerability in action.sh at line 87. Replaced the unquoted `${GHA_ZIZMOR_INPUTS}` expansion (which allowed shell metacharacter injection via `$(...)`, backticks, `;`, `|`, `&`) with a safe two-step approach: (1) `read -ra zizmor_inputs <<< "${GHA_ZIZMOR_INPUTS}"` to split the value into an array using IFS word-splitting only (no metacharacter interpretation), then (2) `"${zizmor_inputs[@]}"` to expand the array with proper quoting. This preserves the intended whitespace-splitting behavior while preventing shell metacharacter injection. The now-unnecessary `# shellcheck disable=SC2086` comment was also removed.

