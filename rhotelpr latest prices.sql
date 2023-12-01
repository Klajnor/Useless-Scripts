/*
  Получаем срез последних цен по remote-spos
*/

declare @remote varchar(3) = 'TR2'
declare @repl_spos int = 591663

; with _ as (
  select p.inc, row_number() over (partition by p.farinc order by p.rdateonly desc, p.rdate desc, p.inc desc) rn
  from rhotelpr p with (nolock)
  where 1 = 1
    and p.remote = @remote
    and p.spos = @repl_spos
)
select 
  *
from rhotelpr p
  inner join _ on _.inc = p.inc and _.rn = 1
where 1 = 1
  and p.spos = @repl_spos