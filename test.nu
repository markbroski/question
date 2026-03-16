use base.nu
use question.nu
use views.nu 

export def add [] {
  let test = get-new-test-details
  test-insert $test
  new-test-current-set
  question current-display
}

def get-new-test-details [] {
  let hypothesis = input "Hypothesis: "
  let question_id = question current-id
  {hypothesis: $hypothesis question_id: $question_id}
}

def test-insert [test: record] {
  base record-insert test $test
}

def new-test-current-set [] {
  let test_id = base last-id-get test
  base current-set test_id $test_id
}

export def current-set [test_id: int] {
  base current-set test_id $test_id
  current-get
}

export def complete [] {
  let test_id = test-current-id
  let where_clause = base id-where test $test_id
  let is_refuted = base yes-no-input "Did you refute the hypothesis?" | into int
  let is_tested = true | into int
  input "Describe the test results"
  base field-edit test result test_id $test_id
  let record = {is_refuted: $is_refuted is_tested: $is_tested}
  base record-update test $record $where_clause
  if ($is_refuted == 0) {
    let is_question_resolved = base yes-no-input "Did you resolve the question?"
    if $is_question_resolved {
      question resolve $is_question_resolved
    } else {
      question current-display
    }
  } else {
    question current-display
  }
}

export def result-edit [] {
  let test_id = test-current-id
  base field-edit test result test_id $test_id
  question current-display 
}

export def result-view [] {
  let test_id = test-current-id
  base field-view test result test_id $test_id
}


export def current-id [] {
  base current-get test_id
}

export def current-get [] {
  views tests-list | where is_current | first
}

export def list [] {
  views tests-list | enumerate
}
export def list-incomplete [] {
  views tests-list | where not is_tested | enumerate
}
