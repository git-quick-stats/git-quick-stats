#!/bin/bash

# Verify we are in a git repo. Create one if not
# FIXME: All the paths are hardcoded currently and will break if anything
# in this chain moves or gets executed elsewhere. Adjust all of these so
# pathing does not matter as much such as creating a TOP variable that
# does something like TOP=$(cd "$(dirname "$0")" || exit ; pwd -P)
# or maybe leverages Make to handle these as test targets
./tests/test-git/resetgit

. tests/assert.sh -v

src="./git-quick-stats"
assert "$src fail" "Invalid argument

NAME
    git-quick-stats - Simple and efficient way to access various stats in a git repo

SYNOPSIS
    For non-interactive mode: git-quick-stats [OPTIONS]
    For interactive mode: git-quick-stats

DESCRIPTION
    Any git repository contains tons of information about commits, contributors,
    and files. Extracting this information is not always trivial, mostly because
    of a gadzillion options to a gadzillion git commands.

    This program allows you to see detailed information about a git repository.

GENERATE OPTIONS
    -T, --detailed-git-stats
        give a detailed list of git stats
    -R, --git-stats-by-branch
        see detailed list of git stats by branch
    -c, --changelogs
        see changelogs
    -L, --changelogs-by-author
        see changelogs by author
    -S, --my-daily-stats
        see your current daily stats
    -V, --csv-output-by-branch
        output daily stats by branch in CSV format
    -j, --json-output
        save git log as a JSON formatted file to a specified area

LIST OPTIONS
    -b, --branch-tree
        show an ASCII graph of the git repo branch history
    -D, --branches-by-date
        show branches by date
    -C, --contributors
        see a list of everyone who contributed to the repo
    -n, --new-contributors
        list everyone who made their first contribution since a specified date
    -a, --commits-per-author
        displays a list of commits per author
    -d, --commits-per-day
        displays a list of commits per day
    -m, --commits-by-month
        displays a list of commits per month
    -Y, --commits-by-year
        displays a list of commits per year
    -w, --commits-by-weekday
        displays a list of commits per weekday
    -W, --commits-by-author-by-weekday
        displays a list of commits per weekday by author
    -o, --commits-by-hour
        displays a list of commits per hour
    -A, --commits-by-author-by-hour
        displays a list of commits per hour by author
    -z, --commits-by-timezone
        displays a list of commits per timezone
    -Z, --commits-by-author-by-timezone
        displays a list of commits per timezone by author

SUGGEST OPTIONS
    -r, --suggest-reviewers
        show the best people to contact to review code
    -h, -?, --help
        display this help text in the terminal

ADDITIONAL USAGE
    You can set _GIT_SINCE and _GIT_UNTIL to limit the git time log
        ex: export _GIT_SINCE=\"2017-01-20\"
    You can set _GIT_LIMIT for limited output log
        ex: export _GIT_LIMIT=20
    You can set _GIT_LOG_OPTIONS for git log options
        ex: export _GIT_LOG_OPTIONS=\"--ignore-all-space --ignore-blank-lines\"
    You can exclude directories or files from the stats by using pathspec
        ex: export _GIT_PATHSPEC=':!pattern'
    You can set _GIT_MERGE_VIEW to view merge commits with normal commits
        ex: export _GIT_MERGE_VIEW=enable
    You can also set _GIT_MERGE_VIEW to only show merge commits
        ex: export _GIT_MERGE_VIEW=exclusive
    You can set _MENU_THEME to display the legacy color scheme
        ex: export _MENU_THEME=legacy
    You can set _GIT_BRANCH to set the branch of the stats
        ex: export _GIT_BRANCH=master
    You can set _GIT_IGNORE_AUTHORS to filter out specific authors
        ex: export _GIT_IGNORE_AUTHORS=\"(author1|author2)\""

assert_raises "$src fail" 1

assert_contains "$src --suggest-reviewers" "Suggested code reviewers (based on git history)"
assert_success "$src --suggest-reviewers"

assert_contains "$src --detailed-git-stats" "Contribution stats"
assert_success "$src --detailed-git-stats"

assert_contains "$src --commits-per-day" "Git commits per date"
assert_success "$src --commits-per-day"

assert_startswith "$src --commits-by-year" "Git commits by year"
assert_success "$src --commits-by-year"

export LC_TIME=POSIX
assert_startswith "$src --commits-by-year" "Git commits by year"
assert_success "$src --commits-by-year"

assert_end
