export def mod-date [] {
  upsert date_modified (date now)
}

export def create-date [] {
  upsert date_created (date now)
}

