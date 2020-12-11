select
  *
from ch.history h
  cross apply ch.uf_showhistorychanges(h.inc) ch
where
  h.stable = 'partner' -- record table
  and h.sinc = 262 -- record id
  --and ch.Field like 'sendmessage%' 
