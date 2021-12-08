select 
  *
from [dbo].[repl_SendClaim_log] l
  left join [dbo].[repl_SendClaim_log_proc] p on p.inc = l.repl_log_procId
  left join [dbo].[repl_SendClaim_log_desc] d on d.inc = l.repl_log_descId
where
  l.claim = 5495112
order by l.inc desc
