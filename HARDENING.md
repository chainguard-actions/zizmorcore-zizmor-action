<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.5.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.5.3** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: `${GHA_ZIZMOR_INPUTS}` is intentionally left unquoted in the `docker run` command in action.sh (line ~97). This variable holds the value of `inputs.inputs`, which is a user-controlled input passed via the `GHA_ZIZMOR_INPUTS` env var. The unquoted expansion allows the shell to perform word-splitting and glob expansion on the attacker-controlled value. Although the value is placed after `--` (preventing flag injection into docker), the unquoted shell variable expansion of untrusted data is still a script-injection risk per rule (b). The fix is to use a proper array or quoted expansion: `"${GHA_ZIZMOR_INPUTS}"` or pass inputs as an array.

Locations:

- `action.sh:97`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Replaced the unquoted `${GHA_ZIZMOR_INPUTS}` expansion in action.sh (line ~97) with a proper xargs-based tokenization into a bash array (`zizmor_inputs`). The fix uses `printf '%s' "${GHA_ZIZMOR_INPUTS}" | xargs printf '%s\0'` piped through a NUL-delimited `while IFS= read -r -d '' t` loop to safely tokenize the whitespace-separated list input with quote-awareness. The array is then expanded as `"${zizmor_inputs[@]}"` in the docker run command, ensuring each token is a separate properly-quoted argument. A guard `if [[ -n "${GHA_ZIZMOR_INPUTS}" ]]` prevents xargs from emitting an empty argument when the input is empty.

