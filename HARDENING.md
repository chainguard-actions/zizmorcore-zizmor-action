<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.6.3

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.6.3** was hardened automatically. 0 finding(s) were identified and resolved across 1 iteration(s).

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

action.sh: GHA_ZIZMOR_INPUTS is now split by the unquoted array assignment `inputs=(${GHA_ZIZMOR_INPUTS})`, marked with `# shellcheck disable=SC2086`. This splits on whitespace and expands globs exactly as upstream did. The array goes to docker run after `--` as ${inputs[@]+"${inputs[@]}"}, which avoids an unbound-variable error under set -u on bash 3.2 when the input is empty.

