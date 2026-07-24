<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.6.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.6.1** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: In action.sh, the env var `${GHA_ZIZMOR_INPUTS}` — which holds the user-controlled `inputs.inputs` value (mapped via `GHA_ZIZMOR_INPUTS: ${{ inputs.inputs }}` in action.yml) — is intentionally left unquoted when passed to `docker run`. The comment in the script acknowledges this (`${GHA_ZIZMOR_INPUTS} is intentionally not quoted`). An unquoted shell expansion of attacker-controlled data allows shell metacharacters (`;`, `|`, `&`, `$(...)`, glob chars, whitespace) to be interpreted by the shell, enabling command injection. The offending line is: `    ${GHA_ZIZMOR_INPUTS} \`

Locations:

- `action.sh:88`
- `action.yml:84`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in action.sh at line 88. The unquoted `${GHA_ZIZMOR_INPUTS}` expansion was replaced with a safe array-based approach: `IFS=' ' read -ra inputs_array <<< "${GHA_ZIZMOR_INPUTS}"` splits the user-controlled input into an array using whitespace word-splitting without interpreting shell metacharacters. The array is then expanded with proper quoting `"${inputs_array[@]}"` in the docker run command. This preserves the intended behavior of accepting multiple whitespace-separated paths while preventing command injection via shell metacharacters.

