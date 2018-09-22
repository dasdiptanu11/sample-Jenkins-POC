/* CHECK COUNT, BACKUP DATA BEFORE DELETE */
declare @patientid int = <<<>>>; /* ####################### CHANGE PATIENT ID BEFORE EXECUTING #################### */

select 'tbl_PatientComplications' as table_name,COUNT(1) as record_count from tbl_PatientComplications where FuId in (select FUId from tbl_FollowUp where PatientId = @patientid) union all 
select 'tbl_FollowUp',COUNT(1) from tbl_FollowUp where PatientId = @patientid union all 
select 'tbl_URN',COUNT(1) from tbl_URN where PatientId = @patientid union all 
select 'tbl_PatientOperationDeviceDtls',COUNT(1) from tbl_PatientOperationDeviceDtls where PatientOperationId in (select OpId from tbl_PatientOperation where PatientId = @patientid) union all 
select 'tbl_PatientOperation',COUNT(1) from tbl_PatientOperation where PatientId = @patientid union all 
select 'tbl_Patient',COUNT(1) from tbl_Patient where PatId = @patientid;

select 'tbl_PatientComplications',* from tbl_PatientComplications where FuId in (select FUId from tbl_FollowUp where PatientId = @patientid);
select 'tbl_FollowUp',* from tbl_FollowUp where PatientId = @patientid;
select 'tbl_URN',* from tbl_URN where PatientId = @patientid;
select 'tbl_PatientOperationDeviceDtls',* from tbl_PatientOperationDeviceDtls where PatientOperationId in (select OpId from tbl_PatientOperation where PatientId = @patientid);
select 'tbl_PatientOperation',* from tbl_PatientOperation where PatientId = @patientid;
select 'tbl_Patient',* from tbl_Patient where PatId = @patientid;
GO



/* DELETE DATA */
begin try
	begin transaction
		declare @patientid int = <<<>>>>; /* ####################### CHANGE PATIENT ID BEFORE EXECUTING #################### */
		
		delete from tbl_PatientComplications where FuId in (select FUId from tbl_FollowUp where PatientId = @patientid);
		select 'tbl_PatientComplications',@@ROWCOUNT;
		
		delete from tbl_FollowUp where PatientId = @patientid;
		select 'tbl_FollowUp',@@ROWCOUNT;
		
		delete from tbl_URN where PatientId = @patientid;
		select 'tbl_URN',@@ROWCOUNT;
		
		delete from tbl_PatientOperationDeviceDtls where PatientOperationId in (select OpId from tbl_PatientOperation where PatientId = @patientid);
		select 'tbl_PatientOperationDeviceDtls',@@ROWCOUNT;
		
		delete from tbl_PatientOperation where PatientId = @patientid;
		select 'tbl_PatientOperation',@@ROWCOUNT;
		
		delete from tbl_Patient where PatId = @patientid;
		select 'tbl_Patient',@@ROWCOUNT;
	commit
end try
begin catch
	rollback transaction;
	print 'transaction is rolled back';
	
	select ERROR_MESSAGE();
end catch