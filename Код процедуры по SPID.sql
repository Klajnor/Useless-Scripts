declare @SPID int = 130
DECLARE @sql_handle binary(20), @stmt_start int, @stmt_end int

SELECT @sql_handle = sql_handle, @stmt_start = stmt_start/2, @stmt_end = CASE WHEN stmt_end = -1 THEN -1 ELSE stmt_end/2 END
FROM master.dbo.sysprocesses
WHERE spid = @SPID AND ecid = 0

DECLARE @line nvarchar(4000)

SET @line = (SELECT SUBSTRING([text], COALESCE(NULLIF(@stmt_start, 0), 1),
  CASE @stmt_end WHEN -1 THEN DATALENGTH([text]) ELSE (@stmt_end - @stmt_start) END) FROM ::fn_get_sql(@sql_handle))
print @line
