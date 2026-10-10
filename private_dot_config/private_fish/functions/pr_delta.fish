function pr_delta -d "Show a GitHub PR or GitLab MR diff in delta"
  # usage: pr_delta [-s|--side-by-side] [number] [delta options...]; number defaults to glab-tui's row, then the current branch
  argparse --ignore-unknown s/side-by-side -- $argv; or return
  set -l delta_opts --paging=always
  set -q _flag_side_by_side; and set -a delta_opts --side-by-side

  set -l number $argv[1]
  set -e argv[1]
  test -n "$number"; or set number $GLAB_TUI_PR_NUMBER
  set -q GLAB_TUI_REPO_PATH; and cd $GLAB_TUI_REPO_PATH

  if git remote get-url origin | string match -q '*github.com*'
    gh pr diff $number --color=never
  else
    glab mr diff $number --color=never
  end | delta $delta_opts $argv
end
