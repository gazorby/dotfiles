function gtt -d "Init a git repository following a base template in the current direcoty"
    git init
    cp --recursive --dereference $HOME/git/template/* $PWD; and cp --recursive --dereference $HOME/git/template/.* $PWD
    /usr/bin/python -m pip install -U pre-commit --user
    yarn init; and yarn add --dev husky standard-version @commitlint/{config-conventional,cli}
    pre-commit install --hook-type commit-msg
end