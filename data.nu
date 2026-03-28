use constants.nu *
use time.nu

export def load [] {
  if not ($env.question_data_file | path exists) {
    $blank_record | save $env.question_data_file
  }
  open $env.question_data_file
}

# # export def load-df [] {
#   load | load-df-piped
# }

 # export def load-df-piped [] {
 #   let rec = $in
 #   let questions = $rec.questions| polars into-df -s ($question_schema | polars into-schema)
 #   let tests = $rec.tests | polars into-df -s ($test_schema | polars into-schema)
 #   let refs = $rec.refs | polars into-df -s ($ref_schema| polars into-schema)
 #   $questions |
 #   polars join -l -s .t $tests question_id question_id |
 #   polars join -l -s .r $refs question_id question_id |
 #   polars rename date_modified.t test_modified |
 #   polars rename date_created.t test_created |
 #   polars rename date_modified.r ref_modified |
 #   polars rename date_created.r ref_created |
 # }



export def reset [] {
  if (input "Are you sure? (y|n)" | $in) == 'y' {
    $blank_record | save -f $env.question_data_file
  }
}

export def to-file [] {
  tee {
    to nuon -i 2 | save -f $env.question_data_file
    cd ($env.question_data_file | path dirname)
    git add $env.question_data_file
    git commit -m "question auto commit" | ignore
  }
}

export def update-row [path: record<entity_name: string, id_name: string, id_value: int>, values: record] {
  let rec = $in
  let index = $rec | index-of-entity $path
  let cell_path = make-row-path $path.entity_name $index
  $rec |
    update $cell_path (
      $in |
      get $cell_path |
      merge $values |
      time mod-date
  ) | to-file

}

export def get-field-value [path: record<entity_name: string, id_name: string, id_value: int, field_name: string>] {
  get $path.entity_name | where {($in | get $path.id_name) == $path.id_value} | first | get $path.field_name
}

export def index-of-entity [path: record<entity_name: string id_name: string id_value: int>] {
  let rec = $in
  let cell_path = ([item $path.id_name] | into cell-path)
  $rec | get $path.entity_name |
  enumerate |
  where {($in | get $cell_path) == $path.id_value } |
  $in.0.index
}

def make-row-path [entity_name: string index: int] {
  [
    $entity_name
    $index
  ] |
  into cell-path
}
