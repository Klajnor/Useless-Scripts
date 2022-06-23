declare @spid int = null -- or specify here

/* Used if @spid is null */
declare @program_name varchar(max) = 'SQLAgent - TSQL JobStep (Job 0x0BE590C3D004FC4EB1A6FC6B8EED1F6B : Step 9)                                                       '

declare @TempString varchar(max), @jobID_varchar varchar(max), @jobID_binary varbinary(16), @stepID int

if @spid is not null 
begin
  select @program_name = sp.program_name from sys.sysprocesses sp where sp.spid = @spid
end

select @TempString = replace(@program_name, 'SQLAgent - TSQL JobStep (Job ', '')
select @jobID_varchar = substring(@TempString, 0, CHARINDEX(' ', @TempString))

select @TempString = substring(@TempString, CHARINDEX('Step ', @TempString) + 5, 100)
select @TempString = trim(replace(@TempString, ')', ''))
select @stepID = try_convert(int, @TempString)

select @jobID_binary = convert(varbinary(16), @jobID_varchar, 1);
select * from msdb.dbo.sysjobs where job_id = @jobID_binary
select * from msdb.dbo.sysjobsteps where job_id = @jobID_binary and step_id = @stepID

/*
select * from sys.sysprocesses where program_name like '%agent%'
*/
