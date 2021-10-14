declare @remote varchar(3) = 'JOY' -- СЮДА ВПИСАТЬ НУЖНЫЙ КОД из repl_remote

update repl_remote set stopsale_forceGlobal = 1 where remote = @remote

while 1 = 1
begin
  update top(100) rs set rs.global = 1 from repl_stopsale rs where rs.remote = @remote and rs.global <> 1
  if @@ROWCOUNT = 0 break
end

while 1 = 1
begin
  update top(100) s set s.global = 1 from stopsale s
    inner join replcoded rc on rc.remote = @remote and rc.tabals = 'SS' and rc.local_inc = s.inc
  where
    rc.remote = @remote and s.global <> 1
  if @@ROWCOUNT = 0 break
end
