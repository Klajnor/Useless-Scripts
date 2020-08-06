declare @startFrom datetime = dateadd(hour, -24, getdate()) -- '2019-03-21T12:00:00'
declare @remote varchar(3) = 'TUR'

;with _ as (
  select distinct claim from replsentclaim with (nolock) where rdate >= @startFrom
)
select count(*) 
from _ 
  inner join claim c with (nolock) on c.inc = _.claim
  inner join repltour rt with (nolock) on rt.tour = c.tour and rt.direction = @remote

GO 

/* Заявок по часам */
declare @startFrom datetime = dateadd(hour, -24, getdate()) -- '2019-04-08T06:00:00'
declare @remote varchar(3) = 'TUR'

;with _ as (
  select claim, dateadd(hour, datediff(hour, 0, max(rdate)), 0) rhour from replsentclaim with (nolock) where rdate >= @startFrom 
  group by claim
)
select rhour, count(*) 
from _ 
  inner join claim c with (nolock) on c.inc = _.claim
  inner join repltour rt with (nolock) on rt.tour = c.tour and rt.direction = @remote
group by rhour
order by rhour
