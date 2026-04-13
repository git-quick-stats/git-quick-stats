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
assert "$src fail" "Invalid argument: fail

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
    -N, --new-contributors-since-tag
        list everyone who made their first contribution since a specified tag
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

CALENDAR OPTIONS
    -k, --commits-calendar-by-author
        shows a calendar heatmap of commits per day-of-week per month for a given author
    -H, --commits-heatmap
        shows a heatmap of commits per day-of-week per month for the last 30 days

SUGGEST OPTIONS
    -r, --suggest-reviewers
        show the best people to contact to review code
    -h, -?, --help
        display this help text in the terminal

MULTI-REPOSITORY ANALYSIS
    --repository=/path
        Analyze multiple repositories. Can be used multiple times.
        Supported with: -T (detailed-git-stats), -a (commits-per-author), -V (csv-output-by-branch), -j (json-output), -S (my-daily-stats), -C (contributors), -n (new-contributors), -N (new-contributors-since-tag), -d (commits-per-day), -Y (commits-by-year), -m (commits-by-month), -w (commits-by-weekday), -W (commits-by-author-by-weekday), -o (commits-by-hour), -A (commits-by-author-by-hour), -z (commits-by-timezone), -Z (commits-by-author-by-timezone)
    --json-path=/path
        Save path used with multi-repo -j/--json-output. If omitted, you will be prompted.
        Example: git-quick-stats --repository=/repo1 --repository=/repo2 -T
        Example: find /path -type d -name .git -exec dirname {} \\; | xargs -I{} git-quick-stats --repository={} -a

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
    You can change to the legacy color scheme by toggling the variable \"_MENU_THEME\" between \"default\" and \"legacy\".
    You can completely disable the color theme by setting the \"_MENU_THEME\" variable to \"none\".
        ex: export _MENU_THEME=legacy
    You can set _GIT_BRANCH to set the branch of the stats
        ex: export _GIT_BRANCH=master
    You can set _GIT_IGNORE_AUTHORS to filter out specific authors
        ex: export _GIT_IGNORE_AUTHORS=\"(author1|author2)\"
    You can sort contribution stats by field \"name\", \"commits\", \"insertions\", \"deletions\", or \"lines\" - total lines changed and order - \"asc\", \"desc\"
        ex: export _GIT_SORT_BY=\"name-asc\"
    You can set _GIT_DAYS to set the number of days for the heatmap
        ex: export _GIT_DAYS=30"

assert_raises "$src fail" 1

assert_contains "$src --suggest-reviewers" "Suggested code reviewers (based on git history)"
assert_success "$src --suggest-reviewers"

assert_contains "$src --detailed-git-stats" "Contribution stats (by author) on the current branch"
assert_success "$src --detailed-git-stats"

assert_contains "$src --commits-per-day" "Git commits per date"
assert_success "$src --commits-per-day"

assert_startswith "$src --commits-by-year" "Git commits by year"
assert_success "$src --commits-by-year"

export LC_TIME=POSIX
assert_startswith "$src --commits-by-year" "Git commits by year"
assert_success "$src --commits-by-year"

# Multi-repo tests
# Setup test repositories for multi-repo analysis
mkdir -p /tmp/test-repos-test/{repo1,repo2}

# Initialize repo1
cd /tmp/test-repos-test/repo1 || exit 1
git init
git config user.email "author1@example.com"
git config user.name "Author One"
echo "file1" > file1.txt
git add .
git commit -m "Initial commit in repo1"
cd - > /dev/null || exit 1

# Initialize repo2
cd /tmp/test-repos-test/repo2 || exit 1
git init
git config user.email "author2@example.com"
git config user.name "Author Two"
echo "file2" > file2.txt
git add .
git commit -m "Initial commit in repo2"
cd - > /dev/null || exit 1

# Test multi-repo detailed stats
assert_contains "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -T" "Aggregated contribution stats (by author) across multiple repositories"
assert_success "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -T"

# Test multi-repo commits per author
assert_contains "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -a" "Aggregated git commits per author across multiple repositories"
assert_success "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -a"

# Focused regression tests: newly supported multi-repo options
assert_contains "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -d" "Repository: /tmp/test-repos-test/repo1"
assert_contains "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -d" "Git commits per date"
assert_success "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -d"

assert_contains "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -Y" "Repository: /tmp/test-repos-test/repo1"
assert_contains "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -Y" "Git commits by year"
assert_success "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -Y"

assert_contains "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 --commits-by-month" "Repository: /tmp/test-repos-test/repo2"
assert_contains "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 --commits-by-month" "Git commits by month"
assert_success "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 --commits-by-month"

export _GIT_AUTHOR="Author One"
assert_contains "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -W" "Git commits by weekday for author"
assert_success "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -W"
unset _GIT_AUTHOR

assert_contains "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -o" "Git commits by hour"
assert_success "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -o"

assert_contains "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -z" "Git commits by timezone"
assert_success "$src --repository=/tmp/test-repos-test/repo1 --repository=/tmp/test-repos-test/repo2 -z"

# Test invalid repository error handling
assert_raises "$src --repository=/tmp/test-repos-test/repo1 --repository=/invalid-repo -a" 1
assert_contains "$src --repository=/tmp/test-repos-test/repo1 --repository=/invalid-repo -a" "not a valid git repository"

# Cleanup
rm -rf /tmp/test-repos-test

assert_end
