<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.6.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.6.1** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: In action.sh, the variable `${GHA_ZIZMOR_INPUTS}` — which holds the value of `inputs.inputs` (a user-controlled composite action input, set via `GHA_ZIZMOR_INPUTS: ${{ inputs.inputs }}` in action.yml) — is intentionally left unquoted in the `docker run` command: `    ${GHA_ZIZMOR_INPUTS} \`. The unquoted expansion allows the shell to interpret metacharacters (`;`, `|`, `&`, `$(...)`, backticks, glob characters, etc.) present in the input value before passing arguments to docker. While the `--` separator prevents flag injection into docker, it does not prevent the shell from processing metacharacters during word-splitting of the unquoted variable. An attacker who controls `inputs.inputs` can inject arbitrary shell commands. The fix is to use a proper array: store the inputs in a bash array using `read -ra` or similar, then expand with `"${inputs_array[@]}"`.

Locations:

- `action.sh:101`
- `action.yml:89`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script-injection vulnerability in action.sh at line 101. Replaced the unquoted `${GHA_ZIZMOR_INPUTS}` expansion (which allowed shell metacharacter interpretation) with a proper xargs-based tokenization into a bash array. The fix uses `printf '%s' "${GHA_ZIZMOR_INPUTS}" | xargs printf '%s\0'` piped through a NUL-delimited read loop to populate `inputs_array`, then expands it as `"${inputs_array[@]}"` in the docker run command. This preserves quote-aware word-splitting behavior while preventing injection of shell metacharacters (`;`, `|`, `&`, `$(...)`, backticks, etc.). The guard `if [[ -n "${GHA_ZIZMOR_INPUTS}" ]]` prevents xargs from emitting an empty token when the input is empty. The `# shellcheck disable=SC2086` comment was removed as it's no longer needed.

