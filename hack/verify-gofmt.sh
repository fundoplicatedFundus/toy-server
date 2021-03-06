#!/usr/bin/env bash

# Adapted from
# https://github.com/kubernetes/kubernetes/blob/master/hack/verify-gofmt.sh.

set -o errexit
set -o nounset
set -o pipefail

find_files() {
  find . -not \( \
      \( \
        -wholename './.git' \
      \) -prune \
    \) -name '*.go'
}

# gofmt exits with non-zero exit code if it finds a problem unrelated to
# formatting (e.g., a file does not parse correctly). Without "|| true" this
# would have led to no useful error message from gofmt, because the script would
# have failed before getting to the "echo" in the block below.
diff=$(find_files | xargs gofmt -d -s 2>&1) || true
if [[ -n "${diff}" ]]; then
  echo "${diff}" >&2
  echo >&2
  echo "Run ./hack/update-gofmt.sh" >&2
  exit 1
fi
