#!/usr/bin/env nu

export def mdcd [dir: string] {
  mkdir $dir
  commandline -a $'cd ($dir)'
  # Or something that replaces current process... No way.
  # cd $dir
  # exec nu
}
