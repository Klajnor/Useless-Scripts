/* Пробуем найти, когда поставили игнор на repl_hotel */
select 
    d.ignored as 'old value'
  , i.ignored as 'new value'
  , l.* 
from repl_classifier_log as l
cross apply (select 
                 D.c.value('ignored[1]','int') as ignored
              from l.dataDeleted.nodes('/Data') as D(c)
             ) as D
cross apply (select 
                 I.c.value('ignored[1]','int') as ignored
              from l.dataInserted.nodes('/Data') as I(c)
             ) as I
where 1=1
  and l.recordRemote = 'ALK'
  and l.tableName ='[dbo].[repl_hotel]'
  and l.recordFarInc = 202
  and d.ignored  != i.ignored
