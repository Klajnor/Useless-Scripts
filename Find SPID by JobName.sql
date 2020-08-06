/*
select * from msdb.dbo.sysjobs where name like '%integ%'
*/

declare @JobName nvarchar(max) = 'Integration. SAMO-incoming load class'

declare @jobID uniqueidentifier
select @jobID = job_id from msdb.dbo.sysjobs where name = @JobName

select * from sys.sysprocesses where program_name like '%' + master.sys.fn_varbintohexstr(@jobID) + '%'
