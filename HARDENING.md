<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.8.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.8.1** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b): in action.sh, the supporting script run by the composite action's run step, the env var GHA_ZIZMOR_INPUTS (from inputs.inputs) is expanded unquoted straight into the command arguments: `    ${GHA_ZIZMOR_INPUTS} \` (with `# shellcheck disable=SC2086` above). The exemption only covers an unquoted expansion into an array assignment, such as `inputs_list=(${GHA_ZIZMOR_INPUTS})`, with the SC2086/SC2206 directive. This line is a bare argument expansion, so the exemption does not apply. Fix: split the value into an array in the exempt hardened form (`# shellcheck disable=SC2206` then `zizmor_inputs=(${GHA_ZIZMOR_INPUTS})`) and pass it as "${zizmor_inputs[@]}" after `--`.

Locations:

- `action.sh:133`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

action.sh: GHA_ZIZMOR_INPUTS is now split with `zizmor_inputs=(${GHA_ZIZMOR_INPUTS})` (shellcheck SC2206 disabled), which gives the same whitespace split and glob as upstream. It is passed after `--` as ${zizmor_inputs[@]+"${zizmor_inputs[@]}"} so an empty list still works under set -u on bash 3.2 (macOS).

