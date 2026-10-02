<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.6.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.6.2** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: The env var `GHA_ZIZMOR_INPUTS` holds the value of `${{ inputs.inputs }}` (attacker-controlled), and is expanded **unquoted** in the `docker run` command in `action.sh` (`${GHA_ZIZMOR_INPUTS}` without double-quotes). Although it is placed after `--` to prevent flag injection into Docker, the unquoted expansion still allows the shell to perform word-splitting and glob expansion on attacker-supplied data before passing arguments to the container. The offending line is: `    ${GHA_ZIZMOR_INPUTS} \`. The fix is to quote it: `"${GHA_ZIZMOR_INPUTS}"` (or use an array if multi-word splitting is intentional and safe).

Locations:

- `action.sh:88`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed the unquoted `${GHA_ZIZMOR_INPUTS}` expansion in action.sh (line 88). Replaced the unquoted variable expansion (which allowed word-splitting and glob expansion on attacker-controlled data) with a properly tokenized bash array using the xargs-based approach: tokenize the whitespace-separated list with `printf '%s' "${GHA_ZIZMOR_INPUTS}" | xargs printf '%s\0'` into a NUL-delimited stream, read into a `zizmor_inputs` array with a `while IFS= read -r -d '' t` loop, then expand as `"${zizmor_inputs[@]}"` in the docker run command. Added a guard `[[ -n "${GHA_ZIZMOR_INPUTS}" ]]` to prevent xargs from emitting an empty token when the input is empty. Removed the `# shellcheck disable=SC2086` comment that was suppressing the shellcheck warning about the unquoted expansion.

