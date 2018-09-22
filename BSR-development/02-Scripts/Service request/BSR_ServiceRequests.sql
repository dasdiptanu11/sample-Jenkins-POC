

/*Updating Hospital for operation e.g Pat Id 1839 YRAAANTON, DANIELA : Revision op 20/03./2015 Port revision occurred at Epworth Richmond (not THE AVENUE) -*/

select * from tbl_Patient where PatId = #ptid /*Check patient details - verify name*/

/*Check the hospitals' ID*/
select * from tbl_site where SiteName ='THE AVENUE' -- 44
select * from tbl_site where SiteName like '%Epworth Richmond%' -- 14

/*Hospital has to be updated in tbl_patientOperation for operation - fetch the record with data available */
select * from tbl_PatientOperation where PatientId = #ptid  and 
OpStat = 1 and OpDate ='20 march 2015' and Hosp = #siteid

/*Update record*/
update  tbl_PatientOperation set Hosp = 14  where PatientId = #ptid  and 
OpStat = 1 and OpDate ='20 march 2015' and Hosp = #siteid

------------------------------------------------------------------------------------------------------------------

/*Deleting operation eg Pls DELETE Operation Id 4425 for Pat Id 3046 REISSENWEBER, Debbie. 
DELETE this revision op - we do not record endoscopic procedures - data entry error.*/

select * from tbl_patient where patid = #ptid /*Verify patient - name and patID match*/
select * from tbl_PatientOperation  where PatientId  = #ptid and OpId = #opid  /*Verify operation belongs to same patient*/

select * from tbl_PatientOperationDeviceDtls  where PatientOperationId  in 
(select OpId  from tbl_PatientOperation  where PatientId  = #ptid and OpId = #opid)

select * from tbl_FollowUp  where PatientId  =  #ptid and OperationId  = #opid

select * from tbl_PatientComplications  where FuId in 
(select f.FUID from tbl_FollowUp f where PatientId  =  #ptid and OperationId  = #opid)


begin tran 

delete from tbl_PatientComplications  where FuId in 
	(select f.FUID from tbl_FollowUp f where PatientId  =  #ptid and OperationId  = #opid )

delete from tbl_FollowUp  where PatientId  =  #ptid and OperationId  = #opid

delete from tbl_PatientOperationDeviceDtls  where PatientOperationId  in 
(select OpId  from tbl_PatientOperation  where PatientId  = #ptid and OpId =#opid )

delete from tbl_PatientOperation  where PatientId  = #ptid and OpId =#opid

commit

-----------------------------------------------------------------------------------------------------------------------

/*Changing opdate : Pat Id 4122 PARSONS, Alix Operation date should be 26/3/2015, NOT 26/4/2015.*/

set dateformat DMY 

select * from tbl_Patient where PatId = #ptid /*Check patient details - verify name*/

/*Check opstat type*/
select OpStat , * from tbl_PatientOperation where PatientId = #ptid  and OpDate ='26/04/2015' -- get OpID 4034


select * from tbl_FollowUp  where FUVal = 4 and PatientId  =  #ptid and OperationId  = #opid


begin tran t1 

update tbl_PatientOperation set OpDate ='26/03/2015' where  PatientId = #ptid  and OpDate ='26/04/2015'

delete from tbl_FollowUp  where FUVal = 4 and PatientId  =  #ptid and OperationId  = #opid

commit
--------------------------------------------------------------------------------------------------------------

/*Updating operation type 
Pat id 2227 WAINMAN, Robyn
Please UPDATE PRIMARY Operation to Sleeve gastrectomy (not: Not stated/inadeq described)
*/

select * from tbl_Patient where PatId = #ptid /*Check patient details - verify name*/

/*Get procedure ID*/
select * from tlkp_Procedure where description = 'Sleeve gastrectomy' -- Id 5
select * from tlkp_Procedure where description like '%Not stated%' -- 99
/*Get operation*/
select * from tbl_PatientOperation where PatientId =#ptid and OpType = #opid -- 2317
or 
select * from tbl_PatientOperation where PatientId =#ptid and OpRevType  = #opid -- null

/*if OpStat = 0 then */
update tbl_PatientOperation set OpType =  5 where PatientId =#ptid and OpType = 99 

/*elseIf opstat = 1 then 
update tbl_PatientOperation set OpRevType =  5 where PatientId =2227 and OpRevType = 99 
*/
---------------------------------------------------------------------------------------------------

/*Changing primary to Revision 
Pat Id 1701 PATCHING, Marnie
Should be REVISION Op, not PRIMARY Op on 8/4/2014.*/

select * from tbl_Patient where PatId = #ptid /*Check patient details - verify name*/
select * from tbl_PatientOperation where PatientId =#ptid and OpStat = 0 and OpDate = '08/04/2014' -- OpID : 1799
select * from tbl_FollowUp where OperationId = #opid and FUPeriodId > 0 -- keep 1st and delete rest 

begin tran t1 



/*Differences:

			Opstat		Optype				OpRevType					OthPriType								OthRevType									 StWt			stBMI
	
primary			0		from tlkp_Proc		null				   if Optype is other - this will have val			null									Optional		Optional
	Rev				1		 null				from tlkp_Proc         null									if OpRevType is other - this will have val		null			 null
*/

delete from tbl_PatientComplications  where FuId in 
	(select f.FUID from tbl_FollowUp f where OperationId  = #opid and FUPeriodId > 0)

delete from tbl_FollowUp  where OperationId  = #opid and FUPeriodId > 0 -- should delete 10 rows 

update tbl_PatientOperation set OpStat = 1, OpRevType = Optype, Optype = null, OthRevType  = OthPriType, OthPriType = null, StWt = null, stBMI = null, LstBarProc  = 99
where OpId  = #opid and PatientId =#ptid and OpStat = 0 and OpDate = '08/04/2014'
--Only 1 Row updated 

commit

begin tran 

update tbl_Patient set Legacy = 
(case when (select count(PatientId) from tbl_PatientOperation where OpStat = 0 and PatientId = tbl_Patient.PatId) >= 1 then 0 else 1 end)
where tbl_Patient.PatId = #ptid

commit

-----------------------------------------------------------------------------------------------------------------------------------------

/*Changing Revision to Primary
e.g:Pat Id 3941 HILL, Amy
Please ADD PRIMARY OPERATION, dated 9/6/2014 Sleeve gastrectomy at SJOG Murdoch, for H.Chandraratna */

set dateformat dmy


--PatId = 3849 /*Check patient details - verify name*/
select * from tbl_Patient where patid= #ptid  

select * from tbl_PatientOperation where PatientId =#ptid and OpStat = 1 and OpDate ='09/06/2014' -- Get OpID : 4863
select * from tbl_FollowUp where OperationId = #opid -- Follow up change not required - system will generate automatically


/*Differences:

			Opstat		Optype				OpRevType					OthPriType									StWt			stBMI      LastBasrProc

primary			0		from tlkp_Proc		null				   if Optype is other - this will have val			Optional		Optional       null
	
Rev				1		 null				from tlkp_Proc         if OpRevType is other - this will have val		null			 null			needs something



*/

begin tran 

update tbl_PatientOperation set OpStat = 0, Optype = OpRevType, OpRevType = null, OthPriType = OthRevType , OthRevType = null, LstBarProc = null
where OpId  = #opid and PatientId =3941 and OpStat = 1 and OpDate = '09/06/2014'
--Only 1 Row updated

select * from tbl_PatientOperation where OpId  = #opid and PatientId =#ptid 

update tbl_Patient set Legacy = 
(case when (select count(PatientId) from tbl_PatientOperation where OpStat = 0 and PatientId = tbl_Patient.PatId) >= 1 then 0 else 1 end)
where tbl_Patient.PatId = #ptid

select count(PatientId) from tbl_PatientOperation where OpStat = 0 and PatientId = #ptid

select * from tbl_Patient where PatId =#ptid 

commit 
