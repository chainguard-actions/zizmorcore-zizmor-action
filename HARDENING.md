<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.9.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.9.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b): action.sh, the supporting script that the composite step in action.yml runs, expands the workflow-controlled input GHA_ZIZMOR_INPUTS (from `inputs.inputs`) without quotes, directly as a command argument: `    ${GHA_ZIZMOR_INPUTS} \` in the `GH_TOKEN="${GHA_ZIZMOR_TOKEN}" "${zizmor}" "${arguments[@]}" -- ${GHA_ZIZMOR_INPUTS} | tee ...` command. The line above has `# shellcheck disable=SC2086`, but the exemption only covers an array assignment (NAME=($VAR)). This is a direct argument expansion, so the exemption does not apply. The value is split on whitespace and glob characters in it are expanded against the workspace. Fix: put the list into an array first, with the directive on that line, e.g. `# shellcheck disable=SC2086,SC2206` then `inputs=(${GHA_ZIZMOR_INPUTS})`, and pass it quoted as `"${inputs[@]}"` after `--`.

Locations:

- `action.sh:143`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

action.sh: GHA_ZIZMOR_INPUTS is now split into an array with an unquoted assignment, `inputs=(${GHA_ZIZMOR_INPUTS})`, under `# shellcheck disable=SC2086,SC2206`. This splits on whitespace and expands globs exactly as upstream's unquoted expansion did. The array is passed after `--` as ${inputs[@]+"${inputs[@]}"} so it stays quoted and doesn't fail under `set -u` with an empty array on bash 3.2. Upstream's `--` separator and PIPESTATUS handling are unchanged.

