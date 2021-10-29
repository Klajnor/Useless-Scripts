declare @spid int = null -- or specify here

/* Used if @spid is null */
declare @program_name varchar(max) = 'SQLAgent - TSQL JobStep (Job 0x01B9BE86B1BB2B40AD74CB715088D829 : Step 1)'

declare @jobID_varchar varchar(max), @jobID_binary varbinary(16)

if @spid is not null 
begin
  select @program_name = sp.program_name from sys.sysprocesses sp where sp.spid = @spid
end

select @jobID_varchar = replace(@program_name, 'SQLAgent - TSQL JobStep (Job ', '')
select @jobID_varchar = substring(@jobID_varchar, 0, CHARINDEX(' ', @jobID_varchar))

select @jobID_binary = convert(varbinary(16), @jobID_varchar, 1);

select * from msdb.dbo.sysjobs where job_id = @jobID_binary

/*
select * from sys.sysprocesses where program_name like '%agent%'
*/
