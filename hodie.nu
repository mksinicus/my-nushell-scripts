#! /usr/bin/env nu

def main [] {
  let temeritate = {
    labora: 1
    lege: 3
    age: 2
    crea: 4
    ordina: 6
  }
  let fructu = (($temeritate | transpose key value | get key) | each {|labore|
    {
      nomine: $labore, 
      puncto: (($temeritate | get $labore) + (random integer 1..20))
    }
  } | sort-by puncto | transpose -rd)
  echo $fructu
}
