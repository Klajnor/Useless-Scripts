-- Проверить последние штампы по классификаторам по всем подключенным интеграциям
;with r as (
  select ru.user_alias [remote] from repl_user ru
  where 1 = 1
    and ru.user_alias <> 'INT'
)
select
    r.remote
  , s.*
  , ri.changetime
from r
  outer apply (
    select top 1
        l.Last_ChangeStamp
      , l.rdate
    from [dbo].[repl_log] l
      left join [dbo].[repl_log_desc] d on d.inc = l.repl_log_descId
    where 1 = 1
      and l.repl_log_procId in (select p.inc from repl_log_proc p where p.name = '[dbo].[up_repl_GetClass_New]')
      and l.remote = r.remote
      and d.description_short not like '@is_feature_getPriority%'
    order by l.rdate desc
  ) s
  outer apply (
    select top 1 * from replinfo ri with (nolock) where ri.changestamp >= s.Last_ChangeStamp order by ri.changestamp asc
  ) ri
where 1 = 1
  --and rdate >= '20230125'
order by r.remote
