use data.nu
use time.nu
use display.nu
use regex.nu

export def question [] {
  data load |
  update sequence.question ($in.sequence.question + 1) |
  do { |rec|
    update questions ($rec.questions | append (question-record-new $rec)) |
    data to-file |
    display question-piped $rec.sequence.question
  } $in
}

export def test [] {
  data load |
  update sequence.test ($in.sequence.test + 1) |
  do { |rec|
    update tests ($rec.tests | append (test-record-new $rec)) |
    data to-file |
    display test-piped $rec.sequence.test
  } $in
}

export def ref [] {
  data load |
  update sequence.ref ($in.sequence.ref + 1) |
  do { |rec|
    update refs ($rec.refs | append (ref-record-new $rec)) |
    data to-file |
    display ref-piped $rec.sequence.ref
  } $in
}

def question-record-new [rec: record] {
  {
    parent_id: (get-question-parent $rec)
    question_id: $rec.sequence.question
    question_name: (name-input "New question")
    answer: null
    resolved: false
  } |
  time mod-date | time create-date
}

def test-record-new [rec: record] {
  {
    question_id: (get-test-question $rec)
    test_id: $rec.sequence.test
    hypothesis: (name-input "Hypothesis")
    test_detail: null
    result: 'untested'
  } | time mod-date | time create-date
}

def ref-record-new [rec: record] {
  {
    question_id: (get-question-parent $rec)
    ref_id: $rec.sequence.ref
    ref_name: (name-input "Ref Name")
    url: (input "Url: ")
  } | time mod-date | time create-date
}

def get-question-parent [rec: record] {
  [{question_id: null question_name: "<none>" }] | append (get-questions $rec) | select-question
}

def get-test-question [rec: record] {
  get-questions $rec | select-question
}

def get-questions [rec: record] {
  $rec.questions | sort-by question_name |
}

def select-question [] {
  input list -f -d question_name "Parent Question" | $in.question_id
}



export def name-input [prompt: string] {
  input $"($prompt): " | regex title-case
}
