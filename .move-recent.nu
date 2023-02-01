# .move-recent.nu

export def mv-recent [
  glob: string # Not real glob, I just simulated `*`
  dest: string # Destination
  duration: duration
] {
  ls . | where type == file | where modified > ((date now) - $duration) | 
  get name | if $glob == '*' { $in } else { find $glob } |
  each {
    |e|
    mv -v $e $dest
  } | flatten
}

def-env test [] {
  let dir = $'/tmp/mv-recent-(random uuid)'
  mkdir $dir
  cd $dir
  mkdir goal
  touch test.file
  try { let _ = mv-recent * goal 10sec } catch {
    echo $"(ansi rb)Test failed"
    cd -
    rm -r $dir
    return
  }
  echo 'Test passed'
  cd -
  rm -r $dir
}
