/*
select * from msdb.dbo.sysjobs where name like '%DEA%'
*/

declare @JobName nvarchar(max) = '%DEA%'

declare @Jobs table (
    name nvarchar(max)
  , job_id uniqueidentifier
  , spid int
)

insert into @Jobs (
    name
  , job_id
  , spid
)
select
    j.name
  , j.job_id
  , s.spid
from msdb.dbo.sysjobs j
  outer apply (select top 1 * from sys.sysprocesses where program_name like '%' + master.sys.fn_varbintohexstr(j.job_id) + '%') s
where 1 = 1
  and j.name like @JobName

select * from @Jobs j
order by j.name

--sp_whoisactive 308
