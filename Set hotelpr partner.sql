declare @remote varchar(3) = 'NEF'
declare @partner int = 84634
-- select * from partner where inc = 84634
-- select top 10 * from hotelpr
update repl_remote set pricePartner = @partner where remote = @remote

if OBJECT_ID('tempdb..#allPr') is not null drop table #allPr
create table #allPr (inc int, primary key(inc))

if OBJECT_ID('tempdb..#partPr') is not null drop table #partPr
create table #partPr (inc int, primary key(inc))

insert into #allPr (inc)
select 
  rc.local_inc
from replcoded rc with (nolock)
  inner join hotelpr p with (nolock) on p.inc = rc.local_inc
where
  rc.remote = @remote
  and rc.tabals = 'HR'
  and isnull(p.partner, 0) <> @partner

while 1 = 1
begin
  delete #partPr where 1 = 1
  
  insert into #partPr (inc)
  select top (10000) a.inc from #allPr a
  if @@ROWCOUNT = 0 break


  update p with (rowlock)
  set
    p.partner = @partner
  from hotelpr p 
    inner join #partPr _p on _p.inc = p.inc
  where
    isnull(p.partner, 0) <> @partner
    

  delete a
  from #allPr a
    inner join #partPr p on p.inc = a.inc
end
