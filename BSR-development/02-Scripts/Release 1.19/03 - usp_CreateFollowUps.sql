ALTER PROCEDURE [dbo].[usp_CreateFollowUps]
AS

BEGIN

	exec [usp_UpdatePatientOptoffSts];	

 --   Update fu
 --   set fu.LastUpdatedBy = 'CIDMU_SP', fu.LastUpdatedDateTime = GETDATE(), batchUpdatereason = 'ABCD TEST',
 --       fu.FUVal     = case when fu.FUDate<= GETDATE()and fu.FUVal<>3 and  then 0 
	--				   when fu.FUDate<= GETDATE()and fu.FUVal= 3 then 3 
	--				   when fu.FUDate<= GETDATE()and fu.FUVal= 5 then 5 
	--				   else 4 end 
 --   from tbl_FollowUp fu
 --   inner join  tbl_patient p on p.PatId = fu.PatientId
	--inner join  tbl_PatientOperation po on fu.PatientId = po.PatientId and po.OpId = fu.OperationId
	--inner join  tlkp_FollowUpPeriod fu1 on 'a' = 'a' and fu1.Id = fu.FUPeriodId 
	            		
	
	--where 	
	----fu.FUId is null and (Required for new)
	--DATEDIFF(DAY, po.OpDate , GETDATE() ) >= 20 and 			 
	--coalesce(p.HStatId, 0) = 0	  --Operation should have been done for follow up, patient should be alive			
	--and (po.OpStat = 0			  -- should be primary or 								 
	--	or  fu1.Id < 1                     --For revision
	--	) 
	--and coalesce(po.ProcAban,0) = 0  --Process should not have been abondoned
	--and coalesce(p.OptOffStatId, 0) in (0,2);
		
	/*Removed to call a different job that will process all records without condition.
	Existing will still be called from within the application*/
	--exec [usp_UpdateFollowUpsAsInvalidOrValid];	
	--exec [usp_UpdateFollowUpsAsInvalidOrValid_NightlyJob]
	 
	--insert into tbl_MonitorFollowUp([RunDateTime])  select GETDATE();

END
