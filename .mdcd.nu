#!/usr/bin/env nu

export def-env mdcd [dir: string] {
  # Had to use `def-env`! I didn't know.
  mkdir $dir
  cd $dir
}
