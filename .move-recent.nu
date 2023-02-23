# .move-recent.nu

export def mv-recent [
  glob: glob # Filename glob provided to `ls`, file only (no dir nor symlink)
  dest: string # Destination
  duration: duration
  --save (-s) # Save moving result to nuon
] {
  ls $glob | where type == file | where modified > ((date now) - $duration) | 
  get name | each {
    |e|
    mv -v $e $dest
  } | flatten | str substring '6,' | split column ' to ' | rename 'moved' 'to' |
  if not $save {$in} else {$in | to nuon}
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
