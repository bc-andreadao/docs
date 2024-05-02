#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ] ; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

git config --global --add safe.directory $GITHUB_WORKSPACE || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

find ${GITHUB_WORKSPACE} -type f -name '*.mdx' -exec quality-docs {} + \
  | reviewdog -f=remark-lint \
      -name="remark-lint" \
      -reporter="${INPUT_REPORTER:-github-pr-check}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS} \
      -tee \
      -diff="git diff --unified=0 ${INPUT_BEFORE_COMMIT} ${INPUT_AFTER_COMMIT}"
