<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.5.6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.5.6** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation: In action.sh, the env var `${GHA_ZIZMOR_INPUTS}` — which holds the value of `inputs.inputs` from the calling workflow — is intentionally left unquoted in the `docker run` command (`${GHA_ZIZMOR_INPUTS} \`). This allows the shell to perform word-splitting and glob expansion on attacker-controlled content before passing arguments to docker. While the `--` separator prevents docker from interpreting the values as flags, it does not prevent shell-level metacharacter processing (e.g., glob patterns like `*` expanding to local filenames, or whitespace-separated paths being split). The value should be quoted (`"${GHA_ZIZMOR_INPUTS}"`) or handled via an array to prevent unintended shell expansion of untrusted input.

Locations:

- `action.sh:88`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

In action.sh, replaced the unquoted `${GHA_ZIZMOR_INPUTS}` expansion (which allowed glob expansion and shell metacharacter processing on attacker-controlled content) with a safe xargs-based tokenization into a bash array. The pattern uses `printf '%s' "${GHA_ZIZMOR_INPUTS}" | xargs printf '%s\0'` piped through a NUL-delimited read loop to populate `zizmor_inputs=()`, then expands it as `"${zizmor_inputs[@]}"` in the docker run command. This preserves quote-aware word-splitting (honoring single/double quotes and backslashes) while preventing glob expansion, and is guarded with `if [[ -n "${GHA_ZIZMOR_INPUTS}" ]]` to avoid emitting an empty token when the input is empty.

