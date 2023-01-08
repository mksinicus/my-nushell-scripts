# Check if a number is prime
export def "math is-prime" [] {
  let num = ($in | into int)
  if ($num == 1) { return false }
  mut i = 2
  while ($num // $i >= $i) {
    if ($num mod $i == 0) { return false }
    $i += 1
  }
  return true
}
