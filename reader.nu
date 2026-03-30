use path_info.nu
use constants.nu
use writer.nu

export def read-data-file [] {
  save-blank-record-if-needed
  sync-from-shared-if-needed
  open (path_info data-path)
}

def save-blank-record-if-needed [] {
  if not (path_info data-path | path exists) {
    print "Setting up a new data file"
    $constants.blank_record | writer write-data-file
  }
}

def shared-uuid [] {
  open (path_info share-uuid-path) | str trim
}

def data-uuid [] {
  open (path_info data-uuid-path) | str trim
}

def sync-from-shared-if-needed [] {
  if not (data-and-shared-uuids-match) {
    print "Updating from Shared Directory"
    encrypted-file | save -f (path_info data-path)
    shared-uuid | save -f (path_info data-uuid-path)
  }
}

def data-and-shared-uuids-match [] {
  (data-uuid) == (shared-uuid)
}

def encrypted-file [] {
  open (path_info share-path) | age -d -i ~/.age
}
