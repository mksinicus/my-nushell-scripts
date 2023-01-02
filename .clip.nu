# Clip the stdin to the system clipboard.
export def clip [] {
  $in | into string | xclip -sel clip
}
