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


