#!/usr/bin/env nu

## below are old naive realization
# print -n "Input filename: "
# let filename = (input)
# ffmpeg -i $"($filename)" -vn -acodec copy $"($filename).m4a"

# Use ffmpeg to extract audio from a video
def main [
  --quiet (-q)          # Be quiet!
  # ...filenames: string  # Files to be processed
  filename: string
] {
  # This advanced trick don't work yet!
  # alias ffmpeg = if $quiet { ffmpeg -loglevel +quiet } else { ffmpeg }

  # old good switch
  if $quiet {
    ffmpeg -loglevel quiet -i $filename -vn -acodec copy $"($filename).m4a"
  } else {
    ffmpeg -i $filename -vn -acodec copy $"($filename).m4a"
  }
}
