<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.6.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.6.2** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: In action.sh, the variable `${GHA_ZIZMOR_INPUTS}` — which holds the value of `inputs.inputs` from the calling workflow (set via `GHA_ZIZMOR_INPUTS: ${{ inputs.inputs }}` in action.yml's env: block) — is intentionally unquoted in the `docker run` command: `${GHA_ZIZMOR_INPUTS} \ | tee "${output}"`. While the value is placed after `--` to prevent flag injection, the unquoted shell expansion still allows shell metacharacters (`;`, `|`, `&`, `$(...)`, backticks, glob characters, whitespace splitting) to be interpreted by the shell, enabling command injection from a caller-controlled input.

Locations:

- `action.sh:89`
- `action.yml:95`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script injection vulnerability in action.sh at line 89. The unquoted `${GHA_ZIZMOR_INPUTS}` expansion in the `docker run` command was replaced with a safe array-based approach: `read -ra zizmor_inputs <<< "${GHA_ZIZMOR_INPUTS}"` splits the input on whitespace (IFS) into an array without interpreting shell metacharacters, and `"${zizmor_inputs[@]}"` passes each element as a separate quoted argument. This preserves the intended word-splitting behavior for multiple paths while preventing command injection via shell metacharacters (;, |, &, $(...), backticks, globs). No changes were needed to action.yml since the env: block already correctly isolates the ${{ inputs.inputs }} expression from the shell.

