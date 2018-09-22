/* CHANGING REVISION TO PRIMARY */
/* Differences of fields for PRIMARY or REVISION operation types:
--		============================================================================================================================================================
--																		FIELDS
		------------------------------------------------------------------------------------------------------------------------------------------------------------
				|	Opstat	|		Optype		|	OpRevType		|					OthPriType					|		StWt		|	stBMI	|	LastBasrProc	|
		============================================================================================================================================================

PRIMARY				0			from tlkp_Proc		null				if Optype is other - this will have val				Optional		Optional	null
	
REVISION			1			null				from tlkp_Proc      if OpRevType is other - this will have val			null			 null		needs something

*/
declare @patientid int = 3935;
select * from dbo.tbl_Patient where PatId = @patientid;
select * from dbo.tbl_URN where PatientID = @patientid;
select * from dbo.tbl_PatientOperation where PatientId = @patientid;
select * from dbo.tbl_FollowUp where OperationId in (select OpId from dbo.tbl_PatientOperation where PatientId = @patientid);
GO


declare @patientid int = 3935;
declare @operationid int = 3849;
begin tran 
	/* update Patient Operation data */
	select * from tbl_PatientOperation where OpId  = @operationid and PatientId = @patientid;
	update dbo.tbl_PatientOperation 
	set	
		OpStat = 0, 
		Optype = OpRevType, 
		OpRevType = null, 
		OthPriType = OthRevType , 
		OthRevType = null, 
		LstBarProc = null
	where OpId  = @operationid 
		and PatientId =	@patientid;
	select * from tbl_PatientOperation where OpId  = @operationid and PatientId = @patientid;

	/* update Patient Legacy flag */
	select 'total patients with PRIMARY ops', count(PatientId) from tbl_PatientOperation where OpStat = 0 and PatientId = @patientid;
	select * from tbl_Patient where PatId = @patientid;
	update tbl_Patient set Legacy = 
			(case when (select count(PatientId) from tbl_PatientOperation where OpStat = 0 and PatientId = tbl_Patient.PatId) >= 1 then 0 else 1 end)
	where tbl_Patient.PatId = @patientid;
	select * from tbl_Patient where PatId = @patientid;
	select 'total patients with PRIMARY ops', count(PatientId) from tbl_PatientOperation where OpStat = 0 and PatientId = @patientid;
commit 