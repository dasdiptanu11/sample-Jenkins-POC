declare @ptid int = 8483;

/* REVIEW AUDIT DATA 
select * from tbl_Patient_Audit where PatId = @ptid and [Action] = 'DELETE'
select * from tbl_FollowUp_Audit where PatientId = @ptid and [Action] = 'DELETE'
select * from tbl_PatientOperation_Audit where PatientId = @ptid and [Action] = 'DELETE'
select * from tbl_URN_Audit where PatientId = @ptid and [Action] = 'DELETE'
select * from tbl_PatientComplications_Audit where FuId in (select fuid from tbl_FollowUp_Audit where PatientId = @ptid and [Action] = 'DELETE')
select * from tbl_PatientOperationDeviceDtls_Audit where PatientOperationId in (select OpId from tbl_PatientOperation_Audit where PatientId = @ptid and [Action] = 'DELETE') and [Action] = 'DELETE'

select * from tbl_Patient where PatId = @ptid
select * from tbl_FollowUp where PatientId = @ptid
select * from tbl_PatientOperation where PatientId = @ptid
select * from tbl_URN where PatientId = @ptid
select * from tbl_PatientComplications where FuId in (select fuid from tbl_FollowUp where PatientId = @ptid)
select * from tbl_PatientOperationDeviceDtls where PatientOperationId in (select OpId from tbl_PatientOperation where PatientId = @ptid)
*/

begin transaction 
	set identity_insert dbo.tbl_Patient ON;
	insert into tbl_Patient (PatId, LastName, FName, TitleId, DOB, DOBNotKnown, GenderId, McareNo, NoMcareNo, DvaNo, NoDvaNo, IHI, AborStatusId, IndiStatusId, NhiNo, NoNhiNo, PriSiteId, PriSurgId, Addr, AddrNotKnown, Sub, StateId, Pcode, NoPcode, CountryId, HomePh, MobPh, NoHomePh, NoMobPh, HStatId, DateDeath, DateDeathNotKnown, CauseOfDeath, DeathRelSurgId, DateESSent, Undel, OptOffStatId, OptOffDate, Legacy, LastUpdatedBy, LastUpdatedDateTime, CreatedBy, CreatedDateTime)
	select PatId, LastName, FName, TitleId, DOB, DOBNotKnown, GenderId, McareNo, NoMcareNo, DvaNo, NoDvaNo, IHI, AborStatusId, IndiStatusId, NhiNo, NoNhiNo, PriSiteId, PriSurgId, Addr, AddrNotKnown, Sub, StateId, Pcode, NoPcode, CountryId, HomePh, MobPh, NoHomePh, NoMobPh, HStatId, DateDeath, DateDeathNotKnown, CauseOfDeath, DeathRelSurgId, DateESSent, Undel, OptOffStatId, OptOffDate, Legacy, LastUpdatedBy, LastUpdatedDateTime, CreatedBy, CreatedDateTime 
	from tbl_Patient_Audit where PatId = @ptid and [Action] = 'DELETE'
	;
	set identity_insert dbo.tbl_Patient OFF;
	
	set identity_insert dbo.tbl_FollowUp ON;
	insert into tbl_FollowUp (FUId, PatientId, OperationId, FUDate, AttmptCallId, SelfRptWt, FUVal, FUPeriodId, RecommendedLTFU, RecommendedLTFUReason, LTFU, LTFUDate, FUWt, FUBMI, PatientFollowUpNotKnown, SEId1, SEId2, SEId3, ReasonOther, DiabStatId, DiabRxId, ReOpStatId, FurtherInfoSlip, FurtherInfoPort, Othinfo, EmailSentToSurg, LastUpdatedBy, LastUpdatedDateTime, CreatedBy, CreatedDateTime, BatchUpdateReason)
	select FUId, PatientId, OperationId, FUDate, AttmptCallId, SelfRptWt, FUVal, FUPeriodId, RecommendedLTFU, RecommendedLTFUReason, LTFU, LTFUDate, FUWt, FUBMI, PatientFollowUpNotKnown, SEId1, SEId2, SEId3, ReasonOther, DiabStatId, DiabRxId, ReOpStatId, FurtherInfoSlip, FurtherInfoPort, Othinfo, EmailSentToSurg, LastUpdatedBy, LastUpdatedDateTime, CreatedBy, CreatedDateTime, BatchUpdateReason 
	from tbl_FollowUp_Audit where PatientId = @ptid and [Action] = 'DELETE'
	;
	set identity_insert dbo.tbl_FollowUp OFF;
	
	set identity_insert dbo.tbl_PatientOperation ON;
	insert into tbl_PatientOperation (OpId, PatientId, Hosp, Surg, OpDate, ProcAban, OpAge, OpStat, OpType, OthPriType, OpRevType, OthRevType, LstBarProc, Ht, HtNtKnown, StWt, StWtNtKnown, StBMI, OpWt, SameOpWt, OpWtNtKnown, OpBMI, DiabStat, DiabRx, RenalTx, LiverTx, Time, OthInfoOp, OpVal, LastUpdatedBy, LastUpdatedDateTime, CreatedBy, CreatedDateTime)
	select OpId, PatientId, Hosp, Surg, OpDate, ProcAban, OpAge, OpStat, OpType, OthPriType, OpRevType, OthRevType, LstBarProc, Ht, HtNtKnown, StWt, StWtNtKnown, StBMI, OpWt, SameOpWt, OpWtNtKnown, OpBMI, DiabStat, DiabRx, RenalTx, LiverTx, Time, OthInfoOp, OpVal, LastUpdatedBy, LastUpdatedDateTime, CreatedBy, CreatedDateTime 
	from tbl_PatientOperation_Audit where PatientId = @ptid and [Action] = 'DELETE'
	;
	set identity_insert dbo.tbl_PatientOperation OFF;
	
	set identity_insert dbo.tbl_URN ON;
	insert into tbl_URN (URId, PatientID, HospitalID, URNo)
	select URId, PatientID, HospitalID, URNo 
	from tbl_URN_Audit where PatientId = @ptid and [Action] = 'DELETE'
	;
	set identity_insert dbo.tbl_URN OFF;
	
	set identity_insert dbo.tbl_PatientComplications ON;
	insert into tbl_PatientComplications (Id, FuId, ComplicationId, OpId)
	select Id, FuId, ComplicationId, OpId 
	from tbl_PatientComplications_Audit where FuId in (select fuid from tbl_FollowUp_Audit where PatientId = @ptid and [Action] = 'DELETE')
	;
	set identity_insert dbo.tbl_PatientComplications OFF;
	
	set identity_insert dbo.tbl_PatientOperationDeviceDtls ON;
	insert into tbl_PatientOperationDeviceDtls (PatientOperationDevId, PatientOperationId, ParentPatientOperationDevId, DevType, DevBrand, DevOthBrand, DevOthDesc, DevOthMode, DevManuf, DevOthManuf, DevId, DevLotNo, DevPortMethId, PriPortRet, ButtressId, IgnoreDevice)
	select PatientOperationDevId, PatientOperationId, ParentPatientOperationDevId, DevType, DevBrand, DevOthBrand, DevOthDesc, DevOthMode, DevManuf, DevOthManuf, DevId, DevLotNo, DevPortMethId, PriPortRet, ButtressId, IgnoreDevice 
	from tbl_PatientOperationDeviceDtls_Audit where PatientOperationId in (select OpId from tbl_PatientOperation_Audit where PatientId = @ptid and [Action] = 'DELETE') and [Action] = 'DELETE'
	;
	set identity_insert dbo.tbl_PatientOperationDeviceDtls OFF;
COMMIT	