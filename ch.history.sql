select
  *
from ch.history h
  cross apply ch.uf_showhistorychanges(h.inc)
where
  h.stable = 'spos' -- record table
  and h.sinc = 8915 -- record id
