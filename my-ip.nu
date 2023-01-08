#! /usr/bin/nu

def main [
  --proxychains (-p)
] {
  let my_ip = (if $proxychains {
    proxychains curl cip.cc
  } else {
    curl cip.cc
  } | lines | each {|x| if ($x | is-empty) {null} else {$x}} |
    split column ': ' | str trim | transpose -rd)
  $my_ip
}
