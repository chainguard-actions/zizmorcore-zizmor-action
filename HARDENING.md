<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.5.6

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.5.6** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (b): action.sh expands the workflow-controlled env var GHA_ZIZMOR_INPUTS (from `inputs.inputs`) unquoted, as a direct argument to `docker run`: line `    ${GHA_ZIZMOR_INPUTS} \`. There is a '# shellcheck disable=SC2086' above it, but the exception only covers an unquoted expansion inside an array assignment (NAME=($VAR) / NAME=(${VAR})). Here the expansion goes straight into the command's arguments. Fix: split it into an array first, `# shellcheck disable=SC2086` then `inputs_arr=(${GHA_ZIZMOR_INPUTS})`, and pass `"${inputs_arr[@]}"` after `--`.

Locations:

- `action.sh:106`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

In action.sh, GHA_ZIZMOR_INPUTS is now split into inputs_arr=(${GHA_ZIZMOR_INPUTS}) under the shellcheck SC2086 disable. That splits on whitespace and expands globs exactly as upstream's unquoted expansion did. The array is passed after '--' as ${inputs_arr[@]+"${inputs_arr[@]}"}. This form is "${inputs_arr[@]}" plus a guard: older bash running with set -u errors when it expands an empty array, and the guard prevents that.

