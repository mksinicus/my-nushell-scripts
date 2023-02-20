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
    # History of optimization: 1.7s -> 0.7s -> 0.2s
    # Naive `each` -> `par-each` plus `sort-by` -> builtin cellpath commands
    return (open $json_path | transpose name character |
    insert unicode {
      |cols| $cols.character | fmt | get upperhex
    } |
    update character {
      |cols| char -i $cols.character
    })
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
