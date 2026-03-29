use data.nu
use list.nu

export def question [question_id: int] {
  if (verify question $question_id) {
    data load | update questions ($in.questions | where question_id != $question_id) | data to-file |
    $"Question ($question_id) deleted"
  }
}
export def test [test_id: int] {
  if (verify test $test_id) {
    data load | update tests ($in.tests | where test_id != $test_id) | data to-file |
    $"test ($test_id) deleted"
  }
}

export def ref [ref_id: int] {
  if (verify ref $ref_id) {
    data load | update refs ($in.refs | where ref_id != $ref_id) | data to-file |
    $"ref ($ref_id) deleted"
  }
}

def verify [ entity_name: string entity_id: int] {
  let confirm = $"Are you sure you want to delete ($entity_name) ($entity_id)? \(y|n)"
  input $confirm | $in == 'y'
}
