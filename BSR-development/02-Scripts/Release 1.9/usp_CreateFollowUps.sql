
GO

/****** Object:  StoredProcedure [dbo].[usp_CreateFollowUps]    Script Date: 06/02/2016 11:47:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CreateFollowUps]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CreateFollowUps]
GO


GO

/****** Object:  StoredProcedure [dbo].[usp_CreateFollowUps]    Script Date: 06/02/2016 11:47:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[usp_CreateFollowUps]
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
		
		
	exec [usp_UpdateFollowUpsAsInvalidOrValid];	
	 
	insert into tbl_MonitorFollowUp([RunDateTime])  select GETDATE();

END







GO


