/*
select * from msdb.dbo.sysjobs where name like '%DEA%'
*/

declare @JobName nvarchar(max) = '%AL2%'

declare @Jobs table (
    name nvarchar(max)
  , job_id uniqueidentifier
  , spid int
  , login_time datetime
  , diff_ms_login_time_to_now int
  , last_batch datetime
  , diff_ms_last_batch_to_now int
)

insert into @Jobs (
    name
  , job_id
  , spid
  , login_time
  , diff_ms_login_time_to_now
  , last_batch
  , diff_ms_last_batch_to_now
)
select
    j.name
  , j.job_id
  , s.spid
  , s.login_time
  , datediff(second, s.login_time, getdate()) diff_ms_login_time_to_now
  , s.last_batch
  , datediff(second, s.last_batch, getdate()) diff_ms_last_batch_to_now
from msdb.dbo.sysjobs j
  outer apply (select top 1 * from sys.sysprocesses where program_name like '%' + master.sys.fn_varbintohexstr(j.job_id) + '%') s
where 1 = 1
  and j.name like @JobName

select
    'sp_whoisactive @filter = ' + convert(varchar(16), spid) + ', @get_plans = 1' sp_whoisactive_sql
  , 'kill ' + convert(varchar(16), spid) kill_sql
  , *
from @Jobs j
order by j.name

--sp_whoisactive @filter = 340, @get_plans = 1
