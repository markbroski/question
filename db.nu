const db_path = path self | path dirname | path join "questions.sqlite"

export def load [] {
  stor import -f $db_path | ignore
}

export def save-to-file [] {
  rm $db_path
  stor export -f $db_path
  ls $db_path
}

export def backup [] {
  sqlite3 $db_path '.dump' | save -f $env.questions_backup_path
}

