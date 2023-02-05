# .entity.nu

alias remove = do {|x| str replace -a $x ''}
alias replace = do {|x y| str replace -sa $x $y}

export alias ent = entity
export alias went = with-entity

export def entity [
  ...names: string
  --list (-l) # List all symbols
] {
  let json_path = "/home/marco/nu/lib/entities.json"
  if $list {
    # Use par-each to accelerate. On my PC it saves one second on each run.
    return (open $json_path | transpose key value | par-each {
      |e|
      {
        key: $e.key
        value: ($e.value | into hex)
      }
    } | sort-by key | transpose -rd)
  }
  $names | each {
    |name|
    let span = (metadata $name).span
    try {open $json_path | get $name | char -i $in} catch {
      panic {msg: "Invalid input", label: "No such entity", span: $span}
    }
  } | str join
}

export def with-entity [] {
  let strs = $in
  $strs | each {
    |str|
    let span = (metadata $str).span
    mut out = $str
    let pairs = ($str | parse -r '(?<from>&\w+;)' | par-each {
      |e|
      $e | insert 'to' ($e.from | remove '[&;]' | try {entity $in} catch {$e.from})
    })
    for pair in $pairs {
      $out = ($out | replace $pair.from $pair.to)
    }
    $out
  }
}

def panic [info] {
  error make {
    msg: $info.msg
    label: {
      text: $info.label
      start: $info.span.start
      end: $info.span.end
    }
  }
}
