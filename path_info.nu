const file_extension = {nuon: nuon uuid: uuid age: age}

export def data-dir [] {
  $env.question_data_dir
}

export def share-dir [] {
  $env.question_share_dir
}

export def data-path [] {
  build-path (data-dir) $file_extension.nuon
}

export def share-path [] {
  build-path (share-dir) $file_extension.age
}

export def data-uuid-path [] {
  build-path (data-dir) $file_extension.uuid
}

export def share-uuid-path [] {
  build-path (share-dir) $file_extension.uuid
}

def build-path [dir: string ext: string] {
  [[parent stem extension]; [$dir $env.question_context $ext]] | path join | first
}
