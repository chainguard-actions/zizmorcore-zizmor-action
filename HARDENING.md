<!-- markdownlint-disable -->

# Hardening Report: zizmorcore--zizmor-action/v0.8.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **zizmorcore--zizmor-action/v0.8.0** was hardened automatically. 0 finding(s) were identified and resolved across 1 iteration(s).

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

action.sh: GHA_ZIZMOR_INPUTS is now split into an array by an unquoted assignment (zizmor_inputs=(${GHA_ZIZMOR_INPUTS})), which splits on whitespace and expands globs the same way upstream did. The array is then passed quoted after '--'. The ${arr[@]+...} form avoids a set -u error on an empty array under bash 3.2.

