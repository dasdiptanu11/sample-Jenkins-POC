-- with opDetails as (
-- select * from tbl_PatientOperation where ISNULL(opstat,0)=1 )

-- select f.reopstatid,* from tbl_FollowUp f --o.PatientId,o.opdate,f.fudate,o.opstat,f.reopstatid,
-- inner join opDetails o on o.PatientId = f.PatientId
-- where FUPeriodId > 0
-- and ((f.fuperiodid =1 and o.opdate > DATEADD(YEAR, -1,f.fudate)) and (o.opdate <= DATEADD(MONTH, 3,f.fudate))
		 -- or (f.fuperiodid >1 and (o.opdate > DATEADD(MONTH, -9,f.fudate)  and o.opdate <= DATEADD(MONTH, 3,f.fudate)))) 
-- and f.ReOpStatId is null

with opDetails as (
select * from tbl_PatientOperation where ISNULL(opstat,0)=1 )

Update f 
set f.reopstatid =1
from tbl_FollowUp f --o.PatientId,o.opdate,f.fudate,o.opstat,f.reopstatid,
inner join opDetails o on o.PatientId = f.PatientId
where FUPeriodId > 0
and ((f.fuperiodid =1 and o.opdate > DATEADD(YEAR, -1,f.fudate)) and (o.opdate <= DATEADD(MONTH, 3,f.fudate))
		 or (f.fuperiodid >1 and (o.opdate > DATEADD(MONTH, -9,f.fudate)  and o.opdate <= DATEADD(MONTH, 3,f.fudate)))) 
and f.ReOpStatId is null