<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.7.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.7.1** was hardened automatically. 0 finding(s) were identified and resolved across 1 iteration(s).

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

action.sh: GHA_ZIZMOR_INPUTS is now split into an array with `# shellcheck disable=SC2206` `zizmor_inputs=(${GHA_ZIZMOR_INPUTS})`. This splits on whitespace and expands globs exactly as upstream's unquoted use did. The array is passed after `--` as ${zizmor_inputs[@]+"${zizmor_inputs[@]}"}, so an empty value doesn't hit an unbound-variable error under set -u on bash 3.2 (macOS).

