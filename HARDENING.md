<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.5.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.5.2** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: `${GHA_ZIZMOR_INPUTS}` is an unquoted shell variable expansion of user-controlled data (`inputs.inputs`) inside the `docker run` command in `action.sh`. The value is set from `GHA_ZIZMOR_INPUTS: ${{ inputs.inputs }}` in `action.yml` and then expanded without double-quotes in the shell, allowing an attacker to inject shell metacharacters (`;`, `|`, `&`, `$(...)`, glob characters, etc.) via the `inputs` action input. Although the value is placed after `--` (preventing flag injection into docker), the unquoted expansion still allows the shell to perform word-splitting and glob expansion on attacker-controlled content before passing arguments to docker. The offending line is: `    ${GHA_ZIZMOR_INPUTS} \`

Locations:

- `action.sh:105`
- `action.yml:88`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed the script-injection vulnerability in action.sh at line 105. The unquoted `${GHA_ZIZMOR_INPUTS}` expansion (which allowed word-splitting and glob expansion on attacker-controlled content) was replaced with a properly tokenized array. The fix uses `xargs printf '%s\0'` piped through a `while IFS= read -r -d '' t` loop to build a `zizmor_inputs` array, guarded by an `if [[ -n "${GHA_ZIZMOR_INPUTS}" ]]` check to prevent xargs from emitting an empty token on empty input. The array is then expanded as `"${zizmor_inputs[@]}"` (double-quoted) in the docker run command. This approach correctly handles quoted sub-commands (e.g., `sh -c "exit 0"`) without allowing shell metacharacter injection, and is consistent with the xargs tokenization pattern required for argument-list inputs.

