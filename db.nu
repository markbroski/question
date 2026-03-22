const db_path = path self | path dirname | path join "questions.sqlite"
const db_backup_path = path self | path dirname | path join "questions.sql"

export def load [] {
  stor import -f $db_path | ignore
}

export def save-to-file [] {
  rm $db_path
  stor export -f $db_path
  ls $db_path
  backup
}

export def backup [] {
  sqlite3 $db_path '.dump' | save -f $db_backup_path
}

export def restore-from-backup [] {
  rm $db_path
  open -r $db_backup_path | sqlite3 $db_path
}

