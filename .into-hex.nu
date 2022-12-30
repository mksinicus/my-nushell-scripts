# .into-hex.nu

# Convert value to hex
export def "into hex" [] {
  let num = $in
  let hexes = "0123456789abcdef"
  mut num = ($num | into int)
  let minus = (if $num < 0 { $num = 0 - $num; true } else { false })
  mut digits = ""
  loop {
    let remainder = ($num mod 16)
    let digit = ($hexes | str substring $remainder..($remainder + 1))
    $digits = ($digits + $digit)
    $num = $num // 16
    if $num == 0 {
      break
    }
  }
  if $minus { $digits = $digits + "-"}
  $digits | str reverse
}
