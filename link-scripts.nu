#!/usr/bin/env nu

def main [
  --folder (-f): string = "~/nu"
  ] {
  for $name in (ls $folder | get name | parse "{i}.nu" | get i) {
    chmod +x $"($name).nu"
    ln -sf $"($name).nu" $name
  }
}
