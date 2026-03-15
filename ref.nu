
use base.nu
use question.nu
use views.nu

export def add [] {
  let url = input "url: "
  let name = input "name: "
  let description = input "description: "
  let question_id = question current-id 
  let record = {
   reference_name: $name,
   reference_url: $url,
   question_id: $question_id
   description: $description
  }
  print $record
  base record-insert reference $record 
}

export def list [] {
  let question_id = question current-id 
  views refs-list | where question_id == $question_id
}

export def view [reference_id: int] {
  let ref = base query-db $"Select reference_url from reference where reference_id = ($reference_id)" | first | get reference_url
  ^open $ref
}

export def current-set [id: int] {
  base current-set reference_id $id
}

export def current-get [] {
  base current-get reference_id
}

export def url-edit [] {
  base field-edit reference reference_url reference_id (current-get)
}

export def description-edit [] {
  base field-edit reference description reference_id (current-get)
}

export def current-display [] {
  base query-db $"select * from reference where reference_id = (current-get)" | base format-dates 
}



