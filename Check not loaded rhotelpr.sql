select distinct p.spos, rs.*
from rhotelpr p
  inner join repl_hotel rh with (nolock) on rh.remote = p.remote and rh.far_inc = p.hotel and rh.ignored = 0
  left join repl_room r with (nolock) on r.remote = p.remote and r.far_inc = p.room
  left join repl_room rr with (nolock) on rr.remote = p.remote and rr.far_inc = p.rroom

  left join repl_htplace hp with (nolock) on hp.remote = p.remote and hp.far_inc = p.htplace
  left join repl_htplace rhp with (nolock) on rhp.remote = p.remote and rhp.far_inc = p.rhtplace

  left join repl_meal m with (nolock) on m.remote = p.remote and m.far_inc = p.meal
  left join repl_meal rm with (nolock) on rm.remote = p.remote and rm.far_inc = p.rmeal

  left join repl_spos rs on rs.remote = p.remote and rs.far_inc = p.spos
where
  p.remote='SKM' and p.rdateonly>='2021-08-09' and p.status=0
  and exists (select 1 from repl_spos rs where rs.remote='SKM' and rs.far_inc=p.spos)
  and (p.room is null or p.room < 0 or r.ignored = 0)
  and (p.rroom is null or p.rroom < 0 or rr.ignored = 0)
  and (p.htplace is null or p.htplace < 0 or hp.ignored = 0)
  and (p.rhtplace is null or p.rhtplace < 0 or rhp.ignored = 0)
  and (p.meal is null or p.meal < 0 or m.ignored = 0)
  and (p.rmeal is null or p.rmeal < 0 or rm.ignored = 0)