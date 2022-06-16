declare @claim int = 8753555

exec up_repl_getclaimstatus @claim

select 
  *
from [dbo].[repl_SendClaim_log] l
  left join [dbo].[repl_SendClaim_log_proc] p on p.inc = l.repl_log_procId
  left join [dbo].[repl_SendClaim_log_desc] d on d.inc = l.repl_log_descId
where
  l.claim = @claim
order by l.inc desc
