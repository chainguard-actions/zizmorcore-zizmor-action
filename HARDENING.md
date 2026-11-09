<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.5.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.5.3** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b) violation in action.sh, the script run by the composite step in action.yml (`"${GITHUB_ACTION_PATH}/action.sh"`). The workflow-controlled env var GHA_ZIZMOR_INPUTS (from `${{ inputs.inputs }}`) is expanded without quotes straight into the `docker run` argument list: `    ${GHA_ZIZMOR_INPUTS} \`. It sits after `--`, so it can't be read as flags, and it doesn't run `;`, `|` or `$(...)`. But it still splits on whitespace and expands globs. It is not the exempt array-assignment form (`NAME=($VAR)` with `# shellcheck disable=SC2086`). Fix: split it into an array first, e.g. `# shellcheck disable=SC2086` then `zizmor_inputs=(${GHA_ZIZMOR_INPUTS})`, and pass `"${zizmor_inputs[@]}"` to docker run.

Locations:

- `action.sh:106`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed the script-injection finding in action.sh. Untested. Before the `docker run` call, the script now sets `zizmor_inputs=(${GHA_ZIZMOR_INPUTS})` under the existing `# shellcheck disable=SC2086`. This splits on whitespace and expands globs the same way upstream's unquoted variable did. After `--`, the array is passed as `${zizmor_inputs[@]+"${zizmor_inputs[@]}"}`. This form keeps an empty input from erroring under `set -u` on older bash (macOS runners ship 3.2), and an empty input adds no argument at all.

