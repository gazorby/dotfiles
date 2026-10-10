function pr_delta -d "Show a GitHub PR or GitLab MR diff in delta"
  # usage: pr_delta [number] [delta options...]; number defaults to glab-tui's row, then the current branch
  set -l number $argv[1]
  set -e argv[1]
  test -n "$number"; or set number $GLAB_TUI_PR_NUMBER
  set -q GLAB_TUI_REPO_PATH; and cd $GLAB_TUI_REPO_PATH

  if git remote get-url origin | string match -q '*github.com*'
    gh pr diff $number --color=never
  else
    glab mr diff $number --color=never
  end | delta --paging=always $argv
end
