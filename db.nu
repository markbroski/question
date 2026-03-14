const db_path = path self | path dirname | path join "questions.sqlite"

export def load [] {
  stor import -f $db_path
}

export def save [] {
  rm $db_path
  stor export -f $db_path
  ls $db_path
}

