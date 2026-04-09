export def title-case [] {
  str replace -r -a '\b\w' { |c| $c | str upcase }
}
