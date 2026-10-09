function lzw --description 'Pick a worktree with lazyworktree and cd into it'
    set -l selection (mktemp)
    lazyworktree --output-selection $selection $argv
    set -l dir (cat $selection)
    rm -f $selection
    test -n "$dir"; and cd $dir
end
