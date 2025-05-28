declare @remote varchar(3) = 'TUR'
declare @repl_log_procId int = (select top 1 p.inc from [dbo].[repl_SendClaim_log_proc] p where p.name = '[dbo].[up_repl_SendClaim]')

declare @top int = 100000 -- уменьшь, если тормозит
declare @hourLimit int = 24*30 -- На сколько часов смотреть наза
if @repl_log_procId is null 
begin
  raiserror('Can''t get @repl_log_procId', 16, 1)
  return
end

declare @repl_log_descId int = (select top 1 d.inc from [dbo].[repl_SendClaim_log_desc] d where d.description = '@Res = 0')

if @repl_log_descId is null 
begin
  raiserror('Can''t get @repl_log_descId', 16, 1)
  return
end

drop table if exists #temp
create table #temp (
    rdate datetime
  , rdate_hour as dateadd(hour, datediff(hour, '20200101', rdate), '20200101')
  , primary key nonclustered (rdate)
)

insert into #temp (
    rdate
)
select top (@top)
    l.rdate
from [dbo].[repl_SendClaim_log] l with (nolock)
where 1 = 1
  and l.remote = @remote
  and l.repl_log_procId = @repl_log_procId
  and l.repl_log_descId = @repl_log_descId
order by
    l.inc desc  

select
    t.rdate_hour
  , datepart(weekday, t.rdate_hour)
  , count(*) cnt
from #temp t
where 1 = 1
  --and datepart(hour, t.rdate_hour) = 15 -- посмотреть срез на определённый час. Открой, если надо
group by 
    rdate_hour
order by
    rdate_hour desc
