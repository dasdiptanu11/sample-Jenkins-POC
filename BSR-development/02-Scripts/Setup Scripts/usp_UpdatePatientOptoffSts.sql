

/****** Object:  StoredProcedure [dbo].[usp_UpdatePatientOptoffSts]    Script Date: 04/14/2015 15:45:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_UpdatePatientOptoffSts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_UpdatePatientOptoffSts]
GO

/****** Object:  StoredProcedure [dbo].[usp_UpdatePatientOptoffSts]    Script Date: 04/14/2015 15:45:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_UpdatePatientOptoffSts]
AS
BEGIN
    /*Updates Optoff status to consented if ESS email was sent 14 days prior and patient is unconsented*/
	UPDATE tbl_Patient SET OptOffStatId = 0, LastUpdatedBy = 'CIDMU_SP', LastUpdatedDateTime = GETDATE()
	where coalesce(OptOffStatId,3) = 3 and coalesce(DateESSent, '01/01/2020') <= (GETDATE() -14) ;	
	
	
   --Commented @ meeting on 10th sepetember	
   /*Updates Optoff status to LTFU if followUp hasn't been done for an year  
	With Last_FollowUp (patientID,Last_PeriodId ) as
	(SELECT patientID, MAX(FUPeriodId) Last_PeriodId from tbl_FollowUp where FUVal in (0,1,2) group by patientID) 
	UPDATE tbl_Patient SET OptOffStatId = 4, LastUpdatedBy = 'CIDMU_SP', LastUpdatedDateTime = GETDATE()     
	where OptOffStatId = 0 and PatId in 
	(
		select LastFollowUpDtls.patientID from tbl_FollowUp LastFollowUpDtls 
		        inner join Last_FollowUp on Last_FollowUp.patientID = LastFollowUpDtls.patientID 
			    and 
			    (LastFollowUpDtls.FUPeriodId = 
			                       case when Last_FollowUp.Last_PeriodId > 0 
			                            then Last_FollowUp.Last_PeriodId - 1 
			                            else Last_FollowUp.Last_PeriodId end )
			inner join tbl_PatientOperation po on po.PatientId =LastFollowUpDtls.patientID 
			                                and po.OpId = LastFollowUpDtls.OperationId  								
		where (LastFollowUpDtls.FUVal in (0,1) and  365 < (case when LastFollowUpDtls.FUPeriodId > 0 then DATEDIFF(DAY,LastFollowUpDtls.FUDate, getdate()) 
		                                                    else DATEDIFF(DAY,po.OpDate , getdate()) end ))                                   
	);
	
	 /*Updates LTFU in follow Up if patient table has optoff sts as 4 and follow up table does not */		
	 update tbl_FollowUp set LTFU = 1, FUVal = 3, batchUpdatereason = '2 FU NOT DONE - LTFU', 
	          LTFUDate = GETDATE(), LastUpdatedBy = 'CIDMU_SP', LastUpdatedDateTime = GETDATE() where FUId in 
	 (select FUId from tbl_FollowUp f inner join tbl_Patient p on PatientId = PatId where p.OptOffStatId = 4 and coalesce(f.LTFU,0) = 0) 
	    and coalesce(FUVal,0)  not in (2,3);*/  
	    
	 /*Updates LTFU in follow Up if patient table has optoff sts as 4 and follow up table does not */		
	 update tbl_FollowUp set LTFU = 1, FUVal = 3, batchUpdatereason = 'PAT UPDATED AS LTFU', 
	          LTFUDate = GETDATE(), LastUpdatedBy = 'CIDMU_SP', LastUpdatedDateTime = GETDATE() where FUId in 
	 (select FUId from tbl_FollowUp f inner join tbl_Patient p on PatientId = PatId where p.OptOffStatId = 4 and coalesce(f.LTFU,0) = 0) 
	    and coalesce(FUVal,0)  not in (2,3);   
	    
END


GO


