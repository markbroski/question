use data.nu


export module questions {

  export def all [] {
    data questions-rollup | polars into-nu | sort-by question_name
  }

  export def resolved [] {
    data questions-rollup | polars into-nu | where resolved | sort-by question_name
  }

  export def unresolved [] {
    data questions-rollup | polars into-nu | where not resolved | sort-by question_name
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
    do $filter $in |
    sort-by question_id
  }



}


