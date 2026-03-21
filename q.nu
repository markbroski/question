

export module db.nu
export module question.nu
export module test.nu
export module views.nu
export module ref.nu
use question.nu
export alias ql = question list
export alias qlu = question list-unresolved
export alias qr = question resolve
export alias qae = question answer-edit
export alias qcd = question current-display
export alias qcs = question current-set
use test.nu
export alias ta = test add
export alias tre = test result-edit 
export alias trv = test result-view
export alias tc = test complete
export alias tl = test list
export alias tli = test list-incomplete
export alias tcs = test current-set
export alias tcg = test current-get 
use ref.nu
export alias ra = ref add
export alias rv = ref view
export alias rl = ref list
export alias rcs = ref current-set 
export alias rcg = ref current-get
