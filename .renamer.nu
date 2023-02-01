# .renamer.nu

# Rename files in the current directory.
export def rnm [
  pattern: string
  new: string
  --hidden (-a) # Include hidden files
  --regex (-r) # Use regex
  --save (-s) # Save renaming result to nuon
] {
  # Closures. Naive, won't work with globs, but fine here
  alias ls = do (if $hidden {{ls -a}} else {{ls}})
  alias replace = do (if $regex {{|x y| str replace -a $x $y}}
                      else {{|x y| str replace -sa $x $y}})
  alias find = do (if $regex {{|x| find -r $x}} else {{|x| find $x}})
  
  ls | get name | find $pattern | each {
    |e| mv -v $e ($e | replace $pattern $new)
  } | flatten | str substring '6,' | split column ' to ' | rename 'moved' 'to' |
  if not $save {$in} else {$in | to nuon}
}
