SELECT [type], quotename(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME([name]), OBJECT_DEFINITION([object_id])
FROM sys.objects
WHERE [type] IN ('P','TR','FN') AND OBJECT_DEFINITION([object_id]) LIKE N'%hotelservice%' -- сюда пиши часть кода
order by quotename(SCHEMA_NAME(schema_id)) + '.' + QUOTENAME([name]) 
