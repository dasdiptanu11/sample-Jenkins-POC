;with last_yr as (
select FUId, PatientId, OperationId , FUDate , DATEADD(YEAR, -1, FUDate) as lst_yr_dt, fuperiodid 
from tbl_FollowUp 
)
, op_data as (
select PatientId, OpId, OpDate, OpStat from dbo.tbl_PatientOperation
)
update tbl_FollowUp 
set ReOpStatId = 1,
LastUpdatedBy = 'cidmu'
where FUId in 
(
select distinct FUId  from last_yr l 
inner join op_data o on l.PatientId = o.PatientId
and l.OperationId != o.OpId
and o.OpDate between lst_yr_dt and FUDate
and o.OpStat != 0 
and l.fuperiodid > 0)