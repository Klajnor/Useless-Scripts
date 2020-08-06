;with c as (
  select
    ric.claim,
    min(ric.changetime) min_changetime,
    case when datediff(d, c.datebeg, convert(date, getdate())) in (0, 1) then 0 else 1 end + case when exists(select 'x' from replsentclaim rs where rs.claim = ric.claim) then 1 else 0 end [priority]
  from REPLINFOCLAIM ric
    left join claim c with (nolock) on c.inc = ric.claim
  group by ric.claim, c.datebeg
)
select
  rt.direction, 
  count(*) [count], 
  sum(case when c.priority = 0 then 1 else 0 end) [0 priority],
  sum(case when c.priority = 1 then 1 else 0 end) [1 priority],
  sum(case when c.priority = 2 then 1 else 0 end) [2 priority],
  min(c.min_changetime) min_changetime
from c
  left join claim cc with (nolock) on cc.inc = c.claim
  left join REPLTOUR rt with (nolock) on rt.tour = cc.tour
group by rt.direction
order by [count] desc
