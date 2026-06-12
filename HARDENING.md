<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.5.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **zizmorcore--zizmor-action/v0.5.2** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: The env var `GHA_ZIZMOR_INPUTS` holds the user-controlled value from `inputs.inputs` and is expanded **unquoted** in the `docker run` shell command in `action.sh`. Although the value is placed after `--` (preventing flag injection into the container), the unquoted bash expansion still allows shell metacharacter injection at the bash level before docker is invoked — e.g. a value containing `$(cmd)`, backticks, semicolons, or glob characters will be interpreted by bash. The code comment even acknowledges this: "${GHA_ZIZMOR_INPUTS} is intentionally not quoted". The fix is to use a proper array populated via `read -ra` or similar safe word-splitting, or to quote the expansion and let the container handle splitting.

Locations:

- `action.sh:97`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed the script injection vulnerability in action.sh at line 97. Replaced the unquoted `${GHA_ZIZMOR_INPUTS}` expansion (with `# shellcheck disable=SC2086`) with a safe two-step approach: (1) `read -ra zizmor_inputs <<< "${GHA_ZIZMOR_INPUTS}"` to split the whitespace-separated inputs into a bash array safely, and (2) `"${zizmor_inputs[@]}"` in the docker run command to expand each element with proper quoting. This preserves the intended word-splitting behavior while preventing shell metacharacter injection (subshell expressions, backticks, semicolons, globs, etc.).

