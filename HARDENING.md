<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.5.6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.5.6** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: The env var `${GHA_ZIZMOR_INPUTS}` — sourced from `inputs.inputs` (user-controlled via `${{ inputs.inputs }}` in action.yml) — is used **unquoted** in the `docker run` command in action.sh. The script explicitly disables shellcheck SC2086 for this line with a comment acknowledging the intentional word-splitting. An unquoted expansion of attacker-controlled data allows the shell to parse metacharacters (glob chars, whitespace splitting) from the value before passing arguments to `docker run`. The `--` separator only prevents flag injection inside the container; it does not prevent shell-level glob expansion or word-splitting of the unquoted variable. The value must be double-quoted: `"${GHA_ZIZMOR_INPUTS}"` (or handled via an array if multi-word splitting is required).

Locations:

- `action.sh:92`
- `action.yml:84`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed the unquoted `${GHA_ZIZMOR_INPUTS}` expansion in action.sh (line 92). Replaced the intentionally-unquoted word-splitting with a safe xargs-based tokenization: the input is piped through `xargs printf '%s\0'` to produce NUL-delimited tokens (honoring quotes and backslashes), which are then read into a bash array via a `while IFS= read -r -d '' t` loop. The array is then expanded as `"${inputs[@]}"` in the docker run command, keeping each token properly quoted and separate. This prevents shell glob expansion and metacharacter injection while preserving the intended behavior of splitting a whitespace-separated list of paths/inputs. The guard `if [[ -n "${GHA_ZIZMOR_INPUTS}" ]]` prevents xargs from emitting a spurious empty token when the variable is empty.

