#! /usr/bin/nu

def main [
  --proxychains (-p)
] {
  if $proxychains {
    proxychains curl cip.cc
  } else {
    curl cip.cc
  }
}
