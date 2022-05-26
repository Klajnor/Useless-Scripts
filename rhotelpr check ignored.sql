;with _ as (
  select distinct
      p.remote
    , p.hotel
    , p.room
    , p.htplace
    , p.meal
  from rhotelpr p
  where 1 = 1
    and p.remote = 'EXI'
    and p.spos = 15351
    and p.status = 0
)
select 
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
from _
  left join repl_hotel   HL on HL.remote = _.remote and HL.far_inc = _.hotel
  left join repl_room    RM on RM.remote = _.remote and RM.far_inc = _.room
  left join repl_htplace HP on HP.remote = _.remote and HP.far_inc = _.htplace
  left join repl_meal    ML on ML.remote = _.remote and ML.far_inc = _.meal
