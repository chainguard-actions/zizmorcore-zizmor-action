<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.6.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.6.3** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: In action.sh, the variable `${GHA_ZIZMOR_INPUTS}` is intentionally left unquoted in the `docker run` command (`${GHA_ZIZMOR_INPUTS} \ | tee "${output}"`). This variable is populated from `${{ inputs.inputs }}` via the `env:` block in action.yml. Because it is unquoted, the shell performs word-splitting and glob expansion on the attacker-controlled value before passing it to docker, enabling command injection through shell metacharacters (`;`, `|`, `&`, `$(...)`, glob patterns, etc.). Even though the value is placed after `--` to prevent flag injection, the unquoted expansion still allows the shell to interpret metacharacters in the value before docker ever sees it.

Locations:

- `action.sh:88`
- `action.yml:88`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed the script injection vulnerability in action.sh at line 88. The unquoted `${GHA_ZIZMOR_INPUTS}` expansion was replaced with a safe xargs-based tokenization into a bash array. The `GHA_ZIZMOR_INPUTS` value (a whitespace-separated list of paths from `${{ inputs.inputs }}`) is now tokenized using `printf '%s' "${GHA_ZIZMOR_INPUTS}" | xargs printf '%s\0'` with a NUL-delimited read loop into `zizmor_inputs=()`. The array is then expanded as `"${zizmor_inputs[@]}"` in the docker run command. This preserves proper word-splitting and quote-handling (e.g., paths with spaces quoted by the user) while preventing shell metacharacter injection. An `if [ -n ... ]` guard ensures xargs is not called on an empty value, which would otherwise produce a spurious empty argument.

