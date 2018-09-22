/* CHANGE OPERATION DATE */
set dateformat mdy;

declare @patientid int = 2866;
select * from dbo.tbl_Patient where PatId = @patientid;
select * from dbo.tbl_PatientOperation where PatientId = @patientid;
select * from dbo.tbl_FollowUp where PatientId = @patientid and FUVal in (select Id from dbo.tlkp_FollowUp_FUVal where Description = 'Not Due');
GO

declare @patientid int = 2866;
declare @operationid int = 2862;
begin transaction
	-- delete those followup which are still not due
	delete from dbo.tbl_FollowUp where PatientId = @patientid and FUVal in (select Id from dbo.tlkp_FollowUp_FUVal where Description = 'Not Due');
	
	-- update operation date
	update dbo.tbl_PatientOperation set OpDate = '20141127' where PatientId = @patientid and OpId = @operationid;
commit