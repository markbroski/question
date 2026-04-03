use path_info.nu

export def write-data-file [] {
    let rec_nuon = $in | to nuon -i 2
    $rec_nuon | save -f (path_info data-path)
    uuidgen | save -f (path_info data-uuid-path)
    commit-data-change
    encrypt-data $rec_nuon
    copy-uuid-to-share-dir
    commit-share-change
}

def encrypt-data [$rec_nuon: string] {
  $rec_nuon | age -e -r $env.age_public_key -a | save -f (path_info share-path)
}

def copy-uuid-to-share-dir [] {
  cp (path_info data-uuid-path) (path_info share-uuid-path)
}

def commit-data-change [] {
  cd (path_info data-dir  )
  git add (path_info data-path )
  git commit -m "question auto commit" | ignore
}

def commit-share-change [] {
  cd (path_info share-dir  )
  git add (path_info share-path)
  git add (path_info share-uuid-path)
  git commit -m "question auto commit" | ignore
}
