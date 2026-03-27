use data.nu
use display.nu

export module question {

  const entity_name = 'questions'
  const id_name = "question_id"

  export def answer [question_id: int] {
    edit-field $question_id "answer"
  }

  export def name [question_id: int] {
    edit-field $question_id "question_name"
  }

  def edit-field [question_id: int field_name: string] {
    let rec = data load
    let cell_path = get-cell-path $rec $entity_name $id_name $question_id $field_name
    edit-path $rec $cell_path | display question-piped $question_id
  }

}

export module test {

  const entity_name = 'tests'
  const id_name = "test_id"

  export def detail [test_id: int] {
    edit-field $test_id "test_detail"
  }

  export def name [test_id: int] {
    edit-field $test_id "test_name"
  }

  def edit-field [test_id: int field_name: string] {
    let rec = data load
    let cell_path = get-cell-path $rec $entity_name $id_name $test_id $field_name
    edit-path $rec $cell_path | display test-piped $test_id
  }

}

export module ref {

  const entity_name = 'refs'
  const id_name = "ref_id"

  export def name [ref_id: int] {
    edit-field $ref_id "ref_name"
  }

  export def url [ref_id: int] {
    edit-field $ref_id "url"
  }

  def edit-field [ref_id: int field_name: string] {
    let rec = data load
    let cell_path = get-cell-path $rec $entity_name $id_name $ref_id $field_name
    edit-path $rec $cell_path | display ref-piped $ref_id
  }

}

def get-cell-path [rec: record, entity_name: string, id_name: string id_value:int field_name: string] {
  let index = index-of-entity $rec $entity_name $id_name $id_value
  make-cell-path $entity_name $index $field_name
}

export def index-of-entity [rec: record entity: string id_name: string id_value: int] {
  let cell_path = ([item $id_name] | into cell-path)
  $rec | get $entity |
  enumerate |
  where {($in | get $cell_path) == $id_value } |
  $in.0.index
}

def edit-path [rec: record cell_path: cell-path] {
  let path = mktemp --dry --suffix '.md' 
  $rec | get $cell_path | save $path
  hx $path
  $rec |
  update $cell_path (open $path | str replace -r '\n$' '') |
  data to-file | 
  tee { rm $path } 

}

def make-cell-path [entity: string index: int field_name: string] {
  [
    $entity
    $index
    $field_name
  ] |
  into cell-path
}
