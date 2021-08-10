/* SI Side */
update repl_user set send_market = 0 where user_alias = 'GLO'
GO



/* ST Side */
declare @remote varchar(3) = 'ALK'
declare @part int = 1000

if object_id('tempdb..#t') is not null drop table #t
create table #t (inc int not null, primary key(inc))

--select top 10 * from rhotelpr where remote = 'ALK'

while 1 = 1
begin
  delete #t where 1 = 1

  insert into #t (inc)
  select top (@part)
    p.inc
  from rhotelpr p with (nolock)
  where
    p.remote = @remote 
    and p.market is not null

  if @@ROWCOUNT = 0 break
  
  update p with (rowlock)
  set
    p.market = null
  from rhotelpr p
    inner join #t t on t.inc = p.inc
  where
    p.remote = @remote 
    and p.market is not null
end



while 1 = 1
begin
  delete #t where 1 = 1

  insert into #t (inc)
  select top (@part)
    p.inc
  from rservicepr p with (nolock)
  where
    1 = 1
    and p.remote = @remote 
    and (p.market is not null or isnull(p.marketlist, '') <> '')

  if @@ROWCOUNT = 0 break
  
  update p with (rowlock)
  set
    p.market = null,
    p.marketlist = null
  from rservicepr p
    inner join #t t on t.inc = p.inc
  where
    1 = 1
    and p.remote = @remote 
    and (p.market is not null or isnull(p.marketlist, '') <> '')
end


while 1 = 1
begin
  delete #t where 1 = 1

  insert into #t (inc)
  select top (@part)
    p.inc
  from hotelpr p with (nolock)
    inner join replcoded rc with (nolock) on rc.remote = @remote and rc.tabals = 'HR' and rc.local_inc = p.inc
  where
    1 = 1
    and p.market is not null

  if @@ROWCOUNT = 0 break
  
  update p with (rowlock)
  set
    p.market = null
  from hotelpr p
    inner join replcoded rc with (nolock) on rc.remote = @remote and rc.tabals = 'HR' and rc.local_inc = p.inc
    inner join #t t on t.inc = p.inc
  where
    1 = 1
    and p.market is not null
end



while 1 = 1
begin
  delete #t where 1 = 1

  insert into #t (inc)
  select top (@part)
    p.inc
  from serviceprice p with (nolock)
    inner join replcoded rc with (nolock) on rc.remote = @remote and rc.tabals = 'PS' and rc.local_inc = p.inc
  where
    1 = 1
    and p.market is not null

  if @@ROWCOUNT = 0 break
  
  update p with (rowlock)
  set
    p.market = null
  from serviceprice p
    inner join replcoded rc with (nolock) on rc.remote = @remote and rc.tabals = 'PS' and rc.local_inc = p.inc
    inner join #t t on t.inc = p.inc
  where
    1 = 1
    and p.market is not null
end
