# .into-hex.nu

# Convert value to hex
export def "into hex" [] {
  let in_dec = $in
  let hexits = "0123456789abcdef"
  mut in_dec = ($in_dec | into int)
  let is_negative = (if $in_dec < 0 { $in_dec = 0 - $in_dec; true } else { false })
  mut out_hex = ""
  loop {
    let remainder = ($in_dec mod 16)
    let hexit = ($hexits | str substring $remainder..($remainder + 1))
    $out_hex = ($out_hex + $hexit)
    $in_dec = $in_dec // 16
    if $in_dec == 0 {
      break
    }
  }
  if $is_negative { $out_hex = $out_hex + "-"}
  $out_hex | str reverse
}
