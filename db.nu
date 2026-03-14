const db_path = path self | path dirname | path join "questions.sqlite"

export def db-load [] {
  stor import -f $db_path
}

export def db-save [] {
  rm $db_path
  stor export -f $db_path
  ls $db_path
}

