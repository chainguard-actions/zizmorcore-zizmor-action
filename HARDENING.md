<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.9.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.9.2** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b): in action.sh, the run step's entrypoint script, the workflow-controlled input `inputs.inputs` (env GHA_ZIZMOR_INPUTS) is expanded unquoted as a command argument: `    ${GHA_ZIZMOR_INPUTS} \` (passed to zizmor after `--`). It is not an array assignment, so the SC2086 exemption does not cover it. Fix: split it into an array first with `# shellcheck disable=SC2086,SC2206` and `inputs=(${GHA_ZIZMOR_INPUTS})`, then pass `"${inputs[@]}"`.

Locations:

- `action.sh:137`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

In action.sh, GHA_ZIZMOR_INPUTS is now split into an array first with `inputs=(${GHA_ZIZMOR_INPUTS})`. This is an unquoted array assignment with SC2086/SC2206 disabled, so the words split and globs expand exactly as upstream's unquoted expansion did. The array is then passed after `--` as ${inputs[@]+"${inputs[@]}"}. That form keeps each argument double-quoted, and it also stops `set -u` from failing on an empty array in older bash (3.2). Not run or tested.

