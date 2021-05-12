SELECT [type], [name], OBJECT_DEFINITION([object_id])
FROM sys.objects
WHERE [type] IN ('P','TR','FN') AND OBJECT_DEFINITION([object_id]) LIKE N'%Your text for search%';
