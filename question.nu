use base.nu
use views.nu

export def add [] {
  let question = get-new-question-details 
  question-insert $question 
  new-question-current-set
  current-display
}

def question-insert [question: record] {
  base record-insert question $question
}

def get-new-question-details [] {
  let question_name = input "Question: "
  let parent_id =  input "Parent Id: " | if ($in | str length) > 0 { $in | into int } else { null }
  {question_name: $question_name parent_id: $parent_id}
}

def new-question-current-set [] {
  let question_id = base last-id-get "question"
  base current-set 'question_id' $question_id
}

export def name-edit [] {
  question-edit question_name
}

export def parent-edit [new_parent_id: int] {
  base record-update question {parent_id: $new_parent_id} (base id-where question (current-id))
  current-display
}

export def answer-edit [] {
  question-edit answer
}

export def answer-view [] {
  base field-view question answer question_id (current-id)
}

export def detail-view [] {
  base field-view question detail question_id (current-id)
}

export def detail-edit [] {
  question-edit detail
}

def question-edit [ field_name: string] {
  base field-edit question $field_name question_id (current-id )
  current-display

}

export def resolve [is_resolved: bool] {
  let question = current-get 
  base record-update question {is_resolved: $is_resolved} (base id-where question $question.question_id)
  if ($question.parent_id | is-not-empty) {
    let activate_parent = base yes-no-input "Do you want to activate the parent question?"
    if $activate_parent {
      current-set $question.parent_id
    }
  }
  current-display
}


export def list-unresolved [] {
  views questions-list | where not is_resolved 
}

export def current-set [question_id: int] {
  base current-set 'question_id' $question_id
  let tests = views tests-list | where question_id == $question_id and is_tested == false | sort-by -r date_modified 
  if ($tests | length) > 0 {
    let test_id = $tests | $in.0.test_id
    base current-set 'test_id' $test_id
  }
}

export def current-id [] {
  base current-get question_id
}

export def current-get [] {
  views questions-list | where is_current | first
}

export def current-display [] {
  let question = current-get
  print $question
  print Tests:
  views tests-list | where question_id == $question.question_id | reject question_id | enumerate
}
