select
  'kill ' + convert(varchar(16), s.spid),
  s.spid,
  cmd=substring(d.text,1,100), 
  stm=left(substring(d.text, (s.stmt_start / 2)+1, (case when s.stmt_end = -1 then len(convert(nvarchar(max), d.text)) * 2 else s.stmt_end end - s.stmt_start) / 2),1000),
  s.spid, s.cpu cpu1, s.physical_io, s.blocked, s.lastwaittype, s.[program_name], s.waitresource
, *
from sys.sysprocesses s
  cross apply sys.dm_exec_sql_text(s.sql_handle) d
where
  s.status not in ('sleeping','background') and s.lastwaittype not in ('oledb')
  and s.lastwaittype  <> 'MEMORY_ALLOCATION_EXT'
--  and substring(d.text,1,100) like '%openquery%'
--  and s.blocked>0
--  and s.cpu>50
order by cpu1 desc
