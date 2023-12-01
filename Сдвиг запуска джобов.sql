; with _ as (
  SELECT top (10000000)
    job.job_id,
    job.notify_level_email,
    job.name,
    job.enabled,
    job.description,
    steps.step_id,
    steps.step_name,
    steps.command,
    steps.server,
    steps.database_name
  FROM
    msdb.dbo.sysjobs job
      INNER JOIN msdb.dbo.sysjobsteps steps ON job.job_id = steps.job_id
  WHERE
    1 = 1
    and job.enabled = 1 -- remove this if you wish to return all jobs
    and job.name like '%load confirm%'
  order by 
    job.name, steps.step_id
)
, 
__ as (
  select row_number() over(order by _.name) * 5rn, _.*, sh.schedule_id from _
    left join msdb.dbo.sysjobschedules jsh on jsh.job_id = _.job_id
    left join msdb.dbo.sysschedules sh on sh.schedule_id = jsh.schedule_id
)
, 
___ as (
  select 
      (rn - rn%60) / 60 min
    , rn%60 sec

    , ((rn - rn%60) / 60) * 100 + rn%60 active_start_time
    , __.*
  from __
)
select 
    N'EXEC msdb.dbo.sp_update_schedule @schedule_id='+ convert(varchar(16), ___.schedule_id) + ', @active_start_time=' + convert(varchar(16), ___.active_start_time)
  , *
from ___
