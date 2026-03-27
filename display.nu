use data.nu

export def question-piped [question_id: int] {
  $in.questions | where question_id == $question_id
}

export def test-piped [test_id: int] {
  $in.tests | where test_id == $test_id
}

export def ref-piped [ref_id: int] {
  $in.refs | where ref_id == $ref_id
}

export def area [area_id: int] {
  data load |
  area-piped $area_id
}

export def area-piped [area_id] {
  let df = $in | data load-df-piped | 
    polars filter-with ((polars col area_id) == $area_id) 

  let area = $df |
    polars select [area_id area_name area_active area_modified area_created] |
    polars unique -s [area_id] |
    polars into-nu | list-to-first 

  let projects = $df |
    polars filter-with ((polars col project_active) | polars fill-null true) |
    polars filter-with ((polars col task_active) | polars fill-null true) |
    polars group-by project_id project_name project_modified project_created |
    polars agg [(polars col task_id | polars count | polars as active_tasks)] |
    polars filter-with ((polars col project_id) | polars is-not-null ) |
    polars sort-by project_name |
    polars into-nu
  {
    area: $area
    active_projects: $projects
  }
}

export def project [project_id: int] {
  data load |
  project-piped $project_id
}

export def project-piped [project_id: int] {
  let df = $in | data load-df-piped | 
    polars filter-with ((polars col project_id ) == $project_id) 
  
  let project = $df |
    polars select [project_id project_name area_id area_name project_active project_someday project_dropped project_modified project_created] |
    polars unique -s [project_id] |
    polars into-nu | list-to-first 

  let tasks = $df |
    polars filter-with ((polars col task_active) | polars fill-null true) |
    polars select [task_id task_name task_modified task_created] |
    polars into-nu
    
  {
    project: $project
    active_tasks: $tasks
  }
}

export def task [task_id: int] {
  data load |
  task-piped $task_id
}

export def task-piped [task_id: int] {
  data load-df-piped |
  polars filter-with ((polars col task_id) == $task_id) |
  polars select [task_id task_name project_id project_name area_id area_name task_active task_dropped task_completed task_modified task_created] |
  polars into-nu |
  list-to-first 
}

def list-to-first [] {
  if ($in | length) == 1 {
    $in | first
  } else {
    null
  }
}
