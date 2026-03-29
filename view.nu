use data.nu

export module question {
  export def answer [question_id: int] {
    data load | $in.questions | where question_id == $question_id | $in.0.answer | glow
  }
}
