use data.nu
use display.nu

export module question {

  const base_path = { entity_name: questions id_name: question_id}

  export def resolved [question_id: int is_resolved: bool = true] {
    let path = $base_path | merge {id_value: $question_id}
    let values = { resolved: $is_resolved }
    data load | data update-row $path $values |
    display question-piped $question_id
  }

}

export module test {

  const entity_name = 'tests'
  const id_name = 'test_id'

  export def refuted [test_id: int] {
    set-result $test_id 'refuted'
  }

  export def tested [test_id: int] {
    set-result $test_id 'tested'
  }

  export def untested [test_id: int] {
    set-result $test_id 'untested'
  }

  def set-result [test_id: int result: string = 'tested'] {
    let rec = data load
    let cell_path = data get-cell-path $rec $entity_name $id_name $test_id 'result'
    $rec | update $cell_path $result| data to-file | display test-piped $test_id
  }

}
