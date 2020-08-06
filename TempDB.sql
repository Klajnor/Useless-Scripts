https://blogs.msdn.microsoft.com/deepakbi/2010/04/13/monitoring-tempdb-transactions-and-space-usage/

https://sqlsunday.com/2013/08/11/shrinking-tempdb-without-restarting-sql-server/

sp_whoisactive --59
--sp_whoisactive @help = 1

--First part of the script
SELECT instance_name AS 'Database',
[Data File(s) Size (KB)]/1024 AS [Data file (MB)],
[Log File(s) Size (KB)]/1024 AS [Log file (MB)],
[Log File(s) Used Size (KB)]/1024 AS [Log file space used (MB)]
FROM (SELECT * FROM sys.dm_os_performance_counters
WHERE counter_name IN
('Data File(s) Size (KB)',
'Log File(s) Size (KB)',
'Log File(s) Used Size (KB)')
AND instance_name = 'tempdb') AS A
PIVOT
(MAX(cntr_value) FOR counter_name IN
([Data File(s) Size (KB)],
[LOG File(s) Size (KB)],
[Log File(s) Used Size (KB)])) AS B
GO
--
--Second part of the script
SELECT create_date AS [Creation date],
recovery_model_desc [Recovery model]
FROM sys.databases WHERE name = 'tempdb'
GO
