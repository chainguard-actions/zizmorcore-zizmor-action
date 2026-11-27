<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.10.0-rc1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.10.0-rc1** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b): in action.sh, the composite step's entrypoint script expands the workflow-controlled env var GHA_ZIZMOR_INPUTS (from inputs.inputs) without quotes as a command argument: `    ${GHA_ZIZMOR_INPUTS} \` (passed to zizmor after `--`). The '# shellcheck disable=SC2086' comment sits above a command invocation, not an array assignment, so the array-assignment exemption does not cover it. Fix: split the list into an array first, with the directive on that line, e.g. `# shellcheck disable=SC2086,SC2206` followed by `zizmor_inputs=(${GHA_ZIZMOR_INPUTS})`, then pass "${zizmor_inputs[@]}" after `--`.

Locations:

- `action.sh:140`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

In action.sh, GHA_ZIZMOR_INPUTS is now split into an array first, with an unquoted assignment and the shellcheck directive (SC2086,SC2206) on that line: zizmor_inputs=(${GHA_ZIZMOR_INPUTS}). This keeps upstream's whitespace splitting and glob expansion. The array goes to zizmor after `--` as ${zizmor_inputs[@]+"${zizmor_inputs[@]}"}, which stays safe under `set -u` when the array is empty (bash 3.2 on macOS fails on an empty array otherwise). Not tested by running it.

