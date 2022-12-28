#!/usr/bin/env nu
# Very naive and incomplete. Forgive me for creating this.
def main [
  ...filenames: string
  --decode (-d)
  --to (-t): string = $"(basename $env.PWD | str trim).tar.orz"
  --non_silent (-n)
] {
  if $decode {
    for f in $filenames {
      orz decode (if not $non_silent {"-s"}) $f | tar -xf -
    }
  } else {
    let to = if ($to | parse "{name}.tar.orz" | length) == 0 {
      $"($to).tar.orz"
    } else { $to } 
    if ((ls).name | find $to) != null {
      rm $to
      echo "Previous archive removed"
    }
    let filenames = ($filenames | each {|it| $"`($it)`"})
    nu -c $"tar -cf - ($filenames | str collect ' ') 
          | orz encode (if not $non_silent {"-s"}) 
          | save --raw ($to)"
  }
}
