--This will convert the complication to the original one
update tbl_PatientComplications
set complicationid = 4
where complicationid = 34

--This will move the complication to the procedures
;with DeleteItems as (
select a.*
from tbl_Complications a
inner join tbl_Complications b on a.ProcedureId=b.ProcedureId and a.ComplicationId=4 and b.ComplicationId=34
)
update tbl_complications 
set ComplicationId = 4
where procedureid not in (select procedureid from deleteitems)
and complicationid=34

--this will delete the duplicates
delete from tbl_Complications
where ComplicationId = 34

--this will get rid of the complication
delete from tlkp_Complications
where id=34
