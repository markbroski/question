const db_name = path self | path dirname | path join "questions.sqlite"
const schema_path = path self | path dirname | path join "schema.sql"

if not ($db_name | path exists) {
  open $schema_path | sqlite3 $db_name
} else {
  print "the database is already set up."
}
