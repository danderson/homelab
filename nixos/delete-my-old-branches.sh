#!/usr/bin/env bash

set -eu

execute="${1:-}"

git remote prune origin

git branch | grep 'danderson/' | sed 's/^* //' | while read -r branch; do
    cnt=$(git show-ref | grep "remotes/origin/${branch}\$" | wc -l)
    if [[ $cnt == 0 ]]; then
        if [[ "$execute" == "do" ]]; then
            git branch -D "$branch"
        else
            echo "delete $branch"
        fi
    fi
done
if [[ "$execute" != "do" ]]; then
    echo
    echo "Dry run. To delete, add 'do' to cmdline."
fi
