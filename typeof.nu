#!/usr/bin/env nu

def main [value: any] {
  $value | describe
}
