select top 100 * from repl_loadclaim_log
where error is not null
order by inc desc
