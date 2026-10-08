function dvdiff -d "Diff two arbitrary files"
  nvim -c "DiffviewDiffFiles $(string replace -a ' ' '\\ ' -- $argv[1]) $(string replace -a ' ' '\\ ' -- $argv[2])"
end
