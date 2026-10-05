#!/usr/bin/env bash
# Pull-request author's version of the producer script. Everything it writes into the
# uploaded artifact is chosen here, including the three metadata files the privileged
# consumer later reads into $GITHUB_ENV.
set -euo pipefail
mkdir -p out-bundle
echo "<!doctype html><title>bundle</title><p>static bundle</p>" > out-bundle/index.html

# a real commit that exists in the base repository, so the consumer's `git fetch` succeeds
echo "$BUNDLE_SHA" > out-bundle/sha

# two lines: the expected value, then one extra assignment
printf 'feature/harmless\nNODE_OPTIONS=--require ./pkg/.static_bundle/payload.js\n' > out-bundle/branch

echo "someorg/somerepo" > out-bundle/slug
cp ci-lab/payload.js out-bundle/payload.js
ls -l out-bundle
echo "--- out-bundle/branch ---"; cat -A out-bundle/branch
