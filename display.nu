use data.nu

export def question [question_id: int] {
  data load | question-piped $question_id
}

export def question-piped [question_id: int] {
  $in.questions | where question_id == $question_id
  {
    question: ($in.questions | where question_id == $question_id | list-to-first | update answer { data cell-trim 50 })
    tests: ($in.tests | where question_id == $question_id | reject question_id | update test_detail { data cell-trim })
    refs: ($in.refs | where question_id == $question_id | reject question_id)
  }
}

export def test-piped [test_id: int] {
  let rec = $in
  let path = {entity_name: tests id_name: test_id id_value: $test_id field_name: question_id}
  let question_id = $rec | data get-field-value $path
  $rec | question-piped $question_id
}

export def ref-piped [ref_id: int] {
  let rec = $in
  let path = {entity_name: refs id_name: ref_id id_value: $ref_id field_name: question_id}
  let question_id = $rec | data get-field-value $path
  $rec | question-piped $question_id
}

def list-to-first [] {
  if ($in | length) == 1 {
    $in | first
  } else {
    null
  }
}
