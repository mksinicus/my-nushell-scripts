# pijul-list
# Lists files tracked by pijul
export def "pj ls" [
  --long (-l) # Get all available columns for each entry
  --repository (-r): path # Set the repository where this command should run. Defaults to the first ancestor of the current directory that contains a `.pijul` directory
] {
  alias pj-ls = do (if $repository != null
    {{^pijul ls --repository $repository}} else
    {{^pijul ls}}
  )
  let lines = (pj-ls | lines);
  alias _ls = do (if $long {{|x| ls -la $x}} else {{|x| ls -a $x}})
  # I don't know how to implement `--repository` with this yet
  _ls **/* | where name in $lines
}
