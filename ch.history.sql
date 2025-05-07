select
  *
from ch.history h
  cross apply ch.uf_showhistorychanges(h.inc) ch
where
  h.stable = 'claim' -- record table
  and h.sinc = 90322989 -- record id
  --and ch.Field like 'sendmessage%' 
order by 
    h.inc desc
