

export const blank_record = {
  questions: []
  tests: []
  refs: []
  sequence: {question: 0 test: 0 ref: 0}
  current: {question: null test: null ref: null}
  review: {questions: []}
}

export const question_schema = {
  question_id: "i64"
  question_name: "str"
  parent_id: "i64"
  answer: "str"
  resolved: "bool"
  date_modified: "datetime<ns, UTC>"
  date_created: "datetime<ns, UTC>"
}

export const test_schema = {
  test_id: "i64"
  hypothesis: "str"
  test_detail: "str"
  question_id: "i64"
  result: "str"
  date_modified: "datetime<ns, UTC>"
  date_created: "datetime<ns, UTC>"
}

export const ref_schema = {
  ref_id: "i64"
  ref_name: "str"
  url: "str"
  question_id: 'i64'
  date_modified: "datetime<ns, UTC>"
  date_created: "datetime<ns, UTC>"
}

