# .into-utf8.nu

# Parse text as hex and print Unicode character.
export def "from unicode" [] {
  $in | into utf8 | decode utf8
}

# Convert hex-represented Unicode into UTF-8
export def "into utf8" [
  --raw (-r) # Output as raw octets instead of Nushell's binary primitive
] {
  # A shame there is not yet pattern matching in Nushell, while `$in` can be
  # used only once and at the beginning of a function.
  let temp = [(metadata $in).span, $in]
  let span = $temp.0
  let in_hexes = $temp.1
  $in_hexes | each {
    |in_hex|
    let in_int = ($in_hex | into int -r 16)
    if $in_int < 0 {
      error make {
        msg: "Invalid hex"
        label: {
          text: "Unicode hex can not be a negative number"
          start: $span.start, end: $span.end
        }
      }
    }
    let octets = if $in_int < 0x80 {
      [] | prepend ($in_int | into radix 2)
    } else {
      get-octets $in_int
    }
    if $raw {
      stringify-octets $octets
    } else {
      binarize-octets $octets
    }
  } | if $raw {
    $in | str join ' '
  } else {
    $in | bytes collect
  }
}

def get-octets [in_int: int] {
  mut octets = []
  mut in_bytes = ($in_int | into radix 2)
  let octet_meta = get-octet-meta $in_int
  let prefix = ($octet_meta | get prefix)
  mut octet_num = ($octet_meta | get octet)
  while $octet_num > 1 {
    $octets = ($octets | prepend (
      "10" + ($in_bytes | str substring '-6,')
    ))
    $in_bytes = ($in_bytes | str substring ',-6')
    if ($in_bytes | str length) < 6 {
      $in_bytes = ($in_bytes | str lpad -l 6 -c '0')
    }
    $octet_num -= 1
  }
  let remaining = (8 - ($prefix | str length))

  $octets | prepend ($prefix + ($in_bytes | str lpad -l $remaining -c '0'))
}

def get-octet-meta [in_int: int] {
  # ASCII-compatibles are previously handled
  [0x800, 0x10000, 0x200000, 0x4000000, 0x80000000] | each {
    |el ind|
    if $in_int < $el {
      {
        prefix: ("0" | str lpad -l ($ind + 3) -c "1"),
        octet: ($ind + 2)
      }
    }
  } | get 0
}

def stringify-octets [octets: list] {
  $octets | each {
    |e| $e | into int -r 2 | into hex | into string | '0x' + $in
  } | str join ' '
}

def binarize-octets [octets: list] {
  $octets | str join | into int -r 2 | into binary |
  bytes remove -a 0x[00] | bytes reverse
}
