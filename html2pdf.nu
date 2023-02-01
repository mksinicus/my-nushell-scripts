#!/usr/bin/env nu

def main [...filenames] {
  $filenames | each {
    |filename|
    let newname = $"($filename).pdf"
    nu -c $'chromium --headless --print-to-pdf=($newname) ($filename)'
    
  }
}
