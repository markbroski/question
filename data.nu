use constants.nu *

export def load [] {
  if not ($env.question_data_file | path exists) {
    $blank_record | save $env.question_data_file
  }
  open $env.question_data_file
}

export def load-df [] {
  load | load-df-piped 
}

# export def load-df-piped [] {
#   let rec = $in
#   let areas = $rec.areas | polars into-df -s ($area_schema | polars into-schema)
#   let projects = $rec.projects | polars into-df -s ($project_schema | polars into-schema)
#   let tasks = $rec.tasks | polars into-df -s ($task_schema | polars into-schema)
#   $areas |
#   polars join -l -s .p $projects area_id area_id |
#   polars join -l -s .t $tasks project_id project_id |
#   polars rename active area_active |
#   polars rename date_modified area_modified |
#   polars rename date_created area_created |
#   polars rename active.p project_active |
#   polars rename someday project_someday |
#   polars rename dropped project_dropped |
#   polars rename completed project_completed |
#   polars rename date_modified.p project_modified |
#   polars rename date_created.p project_created |
#   polars rename active.t task_active |
#   polars rename completed.t task_completed |
#   polars rename dropped.t task_dropped |
#   polars rename date_modified.t task_modified |
#   polars rename date_created.t task_created |
# }

export def reset [] {
  $blank_record | save -f $env.question_data_file
}

export def to-file [] {
  tee {
    to nuon -i 2 | save -f $env.question_data_file
    cd ($env.question_data_file | path dirname)
    git add -A
    git commit -m "question auto commit" | ignore
  }
}


