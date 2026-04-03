use data.nu


export module questions {

  export def all [] {
    data questions-rollup | polars into-nu | row-trim | sort-by question_name | col-select
  }

  export def resolved [] {
    data questions-rollup | polars into-nu | where resolved | row-trim | sort-by question_name | col-select
  }

  export def unresolved [] {
    data questions-rollup | polars into-nu | where not resolved | row-trim | sort-by question_name | col-select
  }

  def row-trim [] {
    update answer { data cell-trim }
  }

  def col-select [] {
    select question_id question_name parent_id 'question_name.p' answer resolved date_modified | rename -c {'question_name.p': parent_name }
  }
}

export module tests {

  export def all [] {
    display {|| $in }
  }

  export def untested [] {
    display {|| where result == untested}
  }

  export def tested [] {
    display {|| where result == tested }
  }

  export def refuted [] {
    display {|| where result == refuted}
  }

  def display [filter: closure] {
    data questions-tests-df |
    polars select test_id hypothesis test_detail result question_id question_name test_modified test_created |
    polars into-nu |
    where { $in.test_id | is-not-empty } |
    do $filter $in |
    row-trim |
    sort-by question_id
  }

  def row-trim [] {
    update test_detail { data cell-trim }
  }
}


