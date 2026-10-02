<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.5.7

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.5.7** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: `${GHA_ZIZMOR_INPUTS}` is unquoted in the `docker run` command in action.sh. This variable is sourced from `inputs.inputs` (user-controlled), mapped via `GHA_ZIZMOR_INPUTS: ${{ inputs.inputs }}` in action.yml. The unquoted shell expansion allows bash to interpret shell metacharacters (`;`, `|`, `&`, `$(...)`, backticks, glob characters) before `docker run` is even invoked. The `--` separator only prevents the value from being treated as flags by the container — it does not prevent bash from processing metacharacters during word-splitting. An attacker-controlled `inputs.inputs` value such as `$(malicious-command) .` would execute arbitrary commands on the runner. The fix is to use `read -ra inputs_array <<< "$GHA_ZIZMOR_INPUTS"` and then pass `"${inputs_array[@]}"` (quoted array expansion) to the docker command.

Locations:

- `action.sh:91`
- `action.yml:82`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed the script injection vulnerability in action.sh at line 91. The unquoted `${GHA_ZIZMOR_INPUTS}` expansion (which allowed shell metacharacters to be interpreted by bash) was replaced with a safe xargs-based tokenization approach. The fix: (1) initializes an empty `inputs_array=()` bash array, (2) guards with `if [[ -n "${GHA_ZIZMOR_INPUTS}" ]]` to prevent xargs from emitting an empty token on empty input, (3) uses `printf '%s' "${GHA_ZIZMOR_INPUTS}" | xargs printf '%s\0'` for quote-aware tokenization that does NOT evaluate shell metacharacters, (4) reads NUL-delimited tokens into the array with `while IFS= read -r -d '' t; do inputs_array+=("$t"); done` (compatible with bash 3.2), and (5) passes `"${inputs_array[@]}"` (quoted array expansion) to docker run. The action.yml file required no changes.

