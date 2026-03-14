use db.nu 
use question.nu 
use base.nu

export alias 'q load' = db db-load  
export alias 'q save' = db db-save 

export alias 'q query' = base query-db

export alias 'q qa' = question question-add 



