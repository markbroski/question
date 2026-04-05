use constants.nu *
use time.nu


export def load [] {
  if not (file-path | path exists) {
    $blank_record | to nuon | age -e -a -r $env.age_public_key | save (file-path)
  }
  open (file-path) | age -d -i ~/.age | from nuon
}

export def to-file [] {
  tee {
    to nuon | age -e -a -r $env.age_public_key | save -f (file-path)
    cd $env.question_data_dir
    git add (file-path)
    git commit -m 'question auto commit' | ignore
  }
}

def file-path [] {
  let base_path = [$env.question_data_dir questions] | path join
  if not ($base_path | path exists) {mkdir $base_path}
  [$base_path $env.question_context] | path join | $"($in).age"
}

export def questions-tests-df [] {
  let rec = load
  let questions = $rec.questions | polars into-df -s ($question_schema | polars into-schema)
  let tests = $rec.tests | polars into-df -s ($test_schema | polars into-schema)
  $questions | polars join -l -s .t $tests question_id question_id | polars rename date_modified.t test_modified | polars rename date_created.t test_created |
}

def tests-rollup [] {
  $in.tests | polars into-df -s ($test_schema | polars into-schema) | polars pivot -o [result] -i [question_id] -v [test_id] -a count --stable
}

def refs-rollup [] {
  $in.refs | polars into-df -s ($ref_schema | polars into-schema) | polars group-by question_id | polars agg [(polars col ref_id | polars count | polars as references)]
}

export def questions-rollup [] {
  let rec = load
  let tests = $rec | tests-rollup
  let refs = $rec | refs-rollup
  let questions = $rec.questions | polars into-df -s ($question_schema | polars into-schema)
  $questions |
  polars join -l $tests question_id question_id |
  polars join -l $refs question_id question_id |
  polars join -l -s ".p" $questions question_id parent_id |
  polars with-column {references: (polars col references |
  polars fill-null 0)}
}

export def reset [] {
  if (input "Are you sure? (y|n)" | $in) == 'y' {
    $blank_record | to-file
  }
}

export def update-row [path: record<entity_name: string, id_name: string, id_value: int> values: record] {
  let rec = $in
  let index = $rec | index-of-entity $path
  let cell_path = make-row-path $path.entity_name $index
  $rec | update $cell_path (
    $in | get $cell_path | merge $values | time mod-date
  ) | to-file
}

export def get-field-value [path: record<entity_name: string, id_name: string, id_value: int, field_name: string>] {
  get $path.entity_name | where { ($in | get $path.id_name) == $path.id_value } | first | get $path.field_name
}

export def index-of-entity [path: record<entity_name: string, id_name: string, id_value: int>] {
  let rec = $in
  let cell_path = ([item $path.id_name] | into cell-path)
  $rec | get $path.entity_name | enumerate | where { ($in | get $cell_path) == $path.id_value } | $in.0.index
}

def make-row-path [entity_name: string index: int] {
  [
    $entity_name
    $index
  ] | into cell-path
}

export def cell-trim [len: int = 15] {
  if ($in | is-not-empty) {
    ($in | str trim | str substring 0..$len) + '...'
  }
}
