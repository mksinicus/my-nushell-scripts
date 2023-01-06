# Clip the stdin to the system clipboard.
export def clip [] {
  $in | into string | str trim -c "\n" | xclip -sel clip
}
