use data.nu
use display.nu

export module question {

  const base_path = {entity_name: questions id_name: question_id}

  export def answer [question_id: int] {
    edit $question_id "answer"
  }

  export def name [question_id: int] {
    edit $question_id "question_name"
  }

  def edit [question_id: int field_name: string] {
    edit-field ($base_path | merge {id_value: $question_id field_name: $field_name}) {|| display question-piped $question_id}
  }

}

export module test {

  const base_path = {entity_name: tests id_name: test_id}

  export def detail [test_id: int] {
    edit $test_id detail
  }

  export def name [test_id: int] {
    edit $test_id test_name
  }

  def edit [test_id: int field_name: string] {
    edit-field ($base_path | merge {id_value: $test_id field_name: $field_name}) {|| display test-piped $test_id}
  }

}

export module ref {

  const base_path = {entity_name: refs id_name:ref_id}

  export def name [ref_id: int] {
    edit $ref_id "ref_name"
  }

  export def url [ref_id: int] {
    edit $ref_id "url"
  }

  def edit [ref_id: int field_name: string] {
    edit-field ($base_path | merge {id_value: $ref_id field_name: $field_name}) {|| display ref-piped $ref_id}
  }

}

def edit-field [path: record<entity_name: string, id_name:string, id_value: int, field_name:string> display: closure ] {
  let rec = data load
  let file_path = mktemp --dry --suffix '.md'
  $rec | data get-field-value $path | save $file_path
  hx $file_path
  let value = open -r $file_path | str replace -r '\n$' ''
  $rec | data update-row $path {$path.field_name: $value} |
  do $display $in
}

