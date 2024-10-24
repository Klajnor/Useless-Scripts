/*
select * from msdb.dbo.sysjobs where name like '%DEA%'
*/

declare @JobName nvarchar(max) = '%AL2%'

declare @Jobs table (
    name nvarchar(max)
  , job_id uniqueidentifier
  , spid int
  , login_time datetime
  , last_batch datetime
)

insert into @Jobs (
    name
  , job_id
  , spid
  , login_time
  , last_batch
)
select
    j.name
  , j.job_id
  , s.spid
  , s.login_time
  , s.last_batch
from msdb.dbo.sysjobs j
  outer apply (select top 1 * from sys.sysprocesses where program_name like '%' + master.sys.fn_varbintohexstr(j.job_id) + '%') s
where 1 = 1
  and j.name like @JobName

select
    'sp_whoisactive @filter = ' + convert(varchar(16), spid) + ', @get_plans = 1'
  , *
from @Jobs j
order by j.name

--sp_whoisactive @filter = 340, @get_plans = 1
