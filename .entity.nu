# .entity.nu

export def entity [
  ...names: string
  --list (-l) # List all symbols
] {
  let json_path = "/home/marco/nu/lib/entities.json"
  if $list {
    return (open $json_path | transpose key value | each {
      |e|
      {
        key: $e.key
        value: ($e.value | into hex)
      }
    } | transpose -rd)
  }
  $names | each {
    |name|
    let span = (metadata $name).span
    try {open $json_path | get $name | char -i $in} catch {
      panic {msg: "Invalid input", label: "No such entity", span: $span}
    }
  } | str join
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
