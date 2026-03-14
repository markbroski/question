use db.nu

const last_save_path = path self | path dirname | path join '.last_saved_date.nuon'

export def query-db [sql: string] {
  stor open | query db $sql
}

export def record-insert [table_name: string record: record] {
  stor insert -t $table_name -d $record
  save-if-necessary
}

export def record-update [table_name: string record: record where_clause?: string] {
  if ($where_clause | is-not-empty) {
    stor update -t $table_name -u $record -w $where_clause
  } else {
    stor update -t $table_name -u $record
  }
  save-if-necessary
}

def save-if-necessary [] {
  let now = date now
  if not ($last_save_path | path exists) {
    let old_date = $now - 10hr
    $old_date | save $last_save_path
  }
  let last_saved_date: datetime = open $last_save_path
  if ($now - $last_saved_date) > 10min {
    db db-save
    $now | save -f $last_save_path
  }
}

export def last-id-get [table: string] {
  let sql = $"SELECT
                    seq
                FROM
                    sqlite_sequence
                WHERE
                    name = '($table)'"
  let result = query-db $sql
  $result | if ($in | length) == 1 { $in | get 0.seq } else { 1 }
}

export def current-set [field_name: string field_value: int] {
  record-update current {$field_name: $field_value}
}

export def current-get [field_name: string] {
  query-db  $"Select ($field_name) from current" | first | get $field_name
}

export def field-edit [table_name: string field_name: string id_name: string id: int] {
  let file_path = mktemp --dry --suffix $"($table_name)_($field_name).md"
  let field_value = query-db $"select ($field_name) from ($table_name) where ($id_name) = ($id)" | first | get $field_name
  $field_value | save $file_path
  hx $file_path
  let field_value = open $file_path
  record-update $table_name {$field_name:$field_value} (id-where $table_name $id)
}

export def id-where [table_name: string id:int] {
  $"($table_name)_id=($id)"
}

export def format-dates [] {
  let rec = $in
  let update_date_modified = {|r| $r.date_modified | into datetime }
  let update_date_created = {|r| $r.date_created | into datetime }
  $rec | update date_modified $update_date_modified | update date_created $update_date_created
}

export def format-bool [field_name: string] {
  update $field_name { |r| $r | get $field_name | into bool}
}

export def trim-string [field_name: string] {
  update $field_name { |r|
    $r | get $field_name |
    if ($in | is-empty) {
      return null
    }
    $in | str substring 0..50
  }
}
