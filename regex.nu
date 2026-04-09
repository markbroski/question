export def title-case [] {
  str replace -a -r '^\w|\s\w' { || str upcase }
}
