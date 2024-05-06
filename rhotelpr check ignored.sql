drop table if exists #acc_variant 

select distinct
    p.remote
  , p.hotel
  , p.room
  , p.htplace
  , p.meal
into #acc_variant
from rhotelpr p
where 1 = 1
  and p.remote = 'ALK'
  and p.hotel = 837
  and p.status = 0
  and p.dateend >= getdate()
  and p.rqdateend >= getdate()
  /* Фильты могу варьироваться. Ещё вероятным вариантом будет фильтр по конкретной акции */

select distinct
    _.*
  , HL.name       HL_name
  , HL.ignored    HL_ignored
  , RM.name       RM_name
  , RM.ignored    RM_ignored
  , HP.name       HP_name
  , HP.ignored    HP_ignored
  , ML.name       ML_name
  , ML.ignored    ML_ignored
  , convert(bit, 
        convert(int, HL.ignored) 
      + convert(int, RM.ignored) 
      + convert(int, HP.ignored) 
      + convert(int, ML.ignored)
    ) total_ignored
from #acc_variant _
  left join repl_hotel   HL on HL.remote = _.remote and HL.far_inc = _.hotel
  left join repl_room    RM on RM.remote = _.remote and RM.far_inc = _.room
  left join repl_htplace HP on HP.remote = _.remote and HP.far_inc = _.htplace
  left join repl_meal    ML on ML.remote = _.remote and ML.far_inc = _.meal

select distinct
    _.remote
  , _.hotel
  , HL.name       HL_name
  , HL.ignored    HL_ignored
from #acc_variant _
  left join repl_hotel   HL on HL.remote = _.remote and HL.far_inc = _.hotel
where 1 = 1
  and HL.ignored = 1

select distinct
    _.remote
  , _.room
  , RM.name       RM_name
  , RM.ignored    RM_ignored
from #acc_variant _
  left join repl_room    RM on RM.remote = _.remote and RM.far_inc = _.room
where 1 = 1
  and RM.ignored = 1

select distinct
    _.remote
  , _.htplace
  , HP.name       HP_name
  , HP.ignored    HP_ignored
from #acc_variant _
  left join repl_htplace HP on HP.remote = _.remote and HP.far_inc = _.htplace
where 1 = 1
  and HP.ignored = 1

select distinct
    _.remote
  , _.meal
  , ML.name       ML_name
  , ML.ignored    ML_ignored
from #acc_variant _
  left join repl_meal    ML on ML.remote = _.remote and ML.far_inc = _.meal
where 1 = 1
  and ML.ignored = 1
