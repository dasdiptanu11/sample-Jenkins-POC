/* CHANGING PRIMARY TO REVISION */
/* Differences of fields for PRIMARY or REVISION operation types:
--		============================================================================================================================================================
--																		FIELDS
		------------------------------------------------------------------------------------------------------------------------------------------------------------
				|	Opstat	|		Optype		|	OpRevType		|					OthPriType					|		StWt		|	stBMI	|	LastBasrProc	|
		============================================================================================================================================================

PRIMARY				0			from tlkp_Proc		null				if Optype is other - this will have val				Optional		Optional	null
	
REVISION			1			null				from tlkp_Proc      if OpRevType is other - this will have val			null			 null		needs something

*/
set dateformat dmy;
GO

declare @patientid int = 2260;
select * from dbo.tbl_Patient where PatId = @patientid;
select * from dbo.tbl_PatientOperation where PatientId = @patientid and OpStat = 0;
select * from dbo.tbl_FollowUp where OperationId in (select OpId from dbo.tbl_PatientOperation where PatientId = @patientid) and FUPeriodId > 0;
select * from dbo.tbl_PatientComplications where FuId in (select FUID from dbo.tbl_FollowUp where OperationId  in (select OpId from dbo.tbl_PatientOperation where PatientId = @patientid) and FUPeriodId > 0);
GO


declare @patientid int = 2260;
declare @operationid int = 2347;
begin tran 
	delete from tbl_PatientComplications where FuId in (select f.FUID from tbl_FollowUp f where OperationId = @operationid and FUPeriodId > 0);
	
	delete from tbl_FollowUp  where OperationId = @operationid and FUPeriodId > 0; /* should delete 10 rows */

	update tbl_PatientOperation 
	set 
		OpStat = 1, 
		OpRevType = Optype, 
		Optype = null, 
		OthRevType  = OthPriType, 
		OthPriType = null, 
		StWt = null, 
		stBMI = null, 
		LstBarProc  = 99
	where PatientId = @patientid 
		and OpStat = 0 
		and OpId = @operationid
	;

	update tbl_Patient 
		set Legacy = (case when (select count(PatientId) from tbl_PatientOperation where OpStat = 0 and PatientId = tbl_Patient.PatId) >= 1 then 0 else 1 end)
	where tbl_Patient.PatId = @patientid
	;
commit