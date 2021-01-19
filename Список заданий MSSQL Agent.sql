SELECT
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
  job.enabled = 1 -- remove this if you wish to return all jobs
  --and steps.command like '%''CAT''%'
order by 
  job.name, steps.step_id
