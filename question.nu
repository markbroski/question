use base.nu
use db.nu

export def question-add [] {
  let question = get-new-question-details 
  question-insert $question 
  question-current-set
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

export def question-current-set [] {
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

export def question-detail-edit [] {
  question-edit detail
}

def question-edit [ field_name: string] {
  base field-edit question $field_name question_id (question-current-id )
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
                base trim-string answer |
                base trim-string detail

}

export def questions-list-unresolved [] {
  questions-list | where not is_resolved 
}

export def current-question-set [question_id: int] {
  current-set 'question_id' $question_id
  question-current-display
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
