#! /bin/bash
#
#    Show the state of every repository beside this script.
#
#    This workspace repository tracks only AGENTS.md, this script and its
#    .gitignore. The repositories it reports on are separate checkouts, each
#    with its own .git, so a plain `git status` here only sees the workspace.
#
#    --common also compares the shared files in each consumer against
#    mqttcommon/ (commonrepos.sh --check), which catches a stale copy.
#
set -uo pipefail

cd "$(dirname "$0")" || exit 1

check_common=0
case "${1:-}" in
    '') ;;
    '--common') check_common=1 ;;
    *)
        echo "Usage: $0 [--common]"
        exit 2
        ;;
esac

status=0

while IFS= read -r git_dir; do
    repo=$(dirname "${git_dir}")
    name=${repo#./}

    output=$(git -C "${repo}" status --short --branch 2>&1)
    printf '=== %s ===\n%s\n' "${name}" "${output}"

    # A clean repository prints only the branch line.
    if [ "$(printf '%s\n' "${output}" | wc -l)" -gt 1 ]; then
        status=1
    fi

    if [ "${check_common}" == '1' ] && grep -qs '^export WEEWX_COMMON_REPOS=' "${repo}/.devenv"; then
        result=$(
            cd "${repo}" || exit 1
            # shellcheck disable=SC1091
            . ./.devenv >/dev/null 2>&1
            commonrepos.sh --check
        )
        common_status=$?

        printf -- '--- shared files: '
        if [ -n "${result}" ]; then
            printf 'drift ---\n%s\n' "${result}"
        else
            printf 'in sync ---\n'
        fi

        [ "${common_status}" == '0' ] || status=1
    fi

    echo
done < <(find . -mindepth 2 -maxdepth 2 -name .git -prune -print | sort)

exit "${status}"
