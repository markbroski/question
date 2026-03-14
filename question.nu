use base.nu
use db.nu

export def question-add [] {
  let question = get-new-question-details 
  question-insert $question 
  new-question-current-set
  question-current-display
}

def question-insert [question: record] {
  base record-insert question $question
}

def get-new-question-details [] {
  let question_name = input "Question: "
  let parent_id =  input "Parent Id: " | if ($in | str length) > 0 { $in | into int } else { null }
  {question_name: $question_name parent_id: $parent_id}
}

export def new-question-current-set [] {
  let question_id = base last-id-get "question"
  base current-set 'question_id' $question_id
}

export def question-name-edit [] {
  question-edit question_name
}

export def question-parent-edit [new_parent_id: int] {
  base record-update question {parent_id: $new_parent_id} (base id-where question (question-current-id))
  question-current-display
}

export def question-answer-edit [] {
  question-edit answer
}

export def question-answer-view [] {
  base field-view question answer question_id (question-current-id)
}

export def question-detail-edit [] {
  question-edit detail
}

def question-edit [ field_name: string] {
  base field-edit question $field_name question_id (question-current-id )
  question-current-display

}

def question-resolve-toggle [] {
  let question = question-current-get 
  let is_resolved = not $question.is_resolved | into int
  base record-update question {is_resolved: $is_resolved} (base id-where question $question.question_id)
  if ($question.parent_id | is-not-empty) {
    let activate_parent = [yes no] | input list "Do you want to activate the parent question?" | match $in {yes => true, no => false}
    if $activate_parent {
      question-current-set $question.parent_id
    }
  }
  question-current-display
}


export def questions-list [] {
  base query-db "SELECT
                    q.question_id,
                    question_name,
                    answer,
                    detail,
                    parent_id,
                    CASE
                        WHEN c.question_id IS NULL THEN 0
                        ELSE 1
                    END is_current,
                    is_resolved,
                    date_created,
                    date_modified
                FROM
                    question q
                    LEFT JOIN current c ON q.question_id = c.question_id
                ORDER BY is_current DESC, date_modified desc" | base format-dates | base format-bool is_current |
                base format-bool is_resolved |
                base trim-string answer 20 |
                base trim-string detail 20

}

export def questions-list-unresolved [] {
  questions-list | where not is_resolved 
}

export def question-current-set [question_id: int] {
  base current-set 'question_id' $question_id
}

export def question-current-id [] {
  base current-get question_id
}

export def question-current-get [] {
  questions-list | where is_current | first
}

export def question-current-display [] {
  question-current-get
}
