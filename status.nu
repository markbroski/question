use data.nu
use display.nu

export module question {

  const base_path = { entity_name: questions id_name: question_id}

  export def resolved [question_id: int is_resolved: bool = true] {
    let values = {resolved: $is_resolved}
    set $question_id $values
  }

  def set [question_id: int values: record] {
    let path = $base_path | merge {id_value: $question_id}
    let display = {|| display question-piped $question_id}
    set-status $path $values $display
  }

}

export module test {

  const base_path = {entity_name: tests id_name: test_id}

  export def refuted [test_id: int] {
    let values = {result: refuted}
    set $test_id $values
  }

  export def tested [test_id: int] {
    let values = {result: tested}
    set $test_id $values
  }

  export def untested [test_id: int] {
    let values = {result: untested}
    set $test_id $values
  }

  def set [test_id: int values: record] {
    let path = $base_path | merge {id_value: $test_id}
    let display = {|| display test-piped $test_id}
    set-status $path $values $display
  }

}

def set-status [path: record<entity_name: string id_name: string, id_value: int> values: record display: closure] {
    data load | data update-row $path $values |
    do $display $in
}
