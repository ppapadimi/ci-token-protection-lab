#!/usr/bin/env bash
# Benign producer script, as it exists on the default branch.
set -euo pipefail
mkdir -p out-bundle
echo "<!doctype html><title>bundle</title><p>static bundle</p>" > out-bundle/index.html
echo "$BUNDLE_SHA"    > out-bundle/sha
echo "$BUNDLE_BRANCH" > out-bundle/branch
echo "$BUNDLE_SLUG"   > out-bundle/slug
