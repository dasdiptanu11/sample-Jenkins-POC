
/****** Object:  StoredProcedure [dbo].[usp_CreateFollowUpsAlerts]    Script Date: 03/31/2015 10:59:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_CreateFollowUpsAlerts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_CreateFollowUpsAlerts]
GO


/****** Object:  StoredProcedure [dbo].[usp_CreateFollowUpsAlerts]    Script Date: 03/31/2015 10:59:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--select * from tlkp_OptOffStatus 

/*Procedure creates entries in tbl_followUp for all patients that are due for followUp*/
CREATE PROCEDURE [dbo].[usp_CreateFollowUpsAlerts]
AS

Begin 	
	
	
	/*Procedure returns Names and details of patients and corresponding surgeons that have followUp val not equal to 2 or 'Done'*/
	select * from 
	(
	
		select fu.FUId FollowID, tt1.Description + ' ' + p.FName + ' ' + p.LastName + ' (UR NO. ' + 
		        urn.URNo + ') ' PatientName, po.OpId OperationID, (ts.SiteName + ' - ' + fu1.Description + case when p.OptOffStatId = 2 then ' (Do not phone)' else '' end ) FU_Period, 
			    tt.Description + ' ' + u.FName + ' ' + u.LastName SurgeonName  , aum.Email SurgeonEmailAdd 
				from tbl_FollowUp fu
				inner join  tlkp_FollowUpPeriod fu1 on fu1.Id = fu.FUPeriodId 
				inner join  tbl_PatientOperation po on fu.PatientId = po.PatientId and fu.OperationId = po.OpId   
				inner join  tbl_Site ts on ts.SiteId  = po.Hosp 
				inner join tbl_Patient p on p.PatId = po.PatientId
				inner join tbl_URN urn on urn.PatientID = p.PatId and urn.HospitalID = ts.SiteId 
				inner join  tlkp_Title tt1 on tt1.Id = p.TitleId 					
				inner join  tbl_User u on u.UserId = case when po.OpStat = 1 then po.Surg else p.PriSurgId end --Primary surgeon is taken for pri op, and actual for rev 
				inner join  tlkp_Title tt on tt.Id = u.TitleId 				
				inner join  aspnet_Membership aum on u.UId = aum.UserId
				where coalesce(FUVal, 0)  in (0,1) and 
					  coalesce(p.HStatId, 0) = 0 and
				      coalesce(p.OptOffStatId, 0) in (0,2) and (EmailSentToSurg is null or EmailSentToSurg <> 1)								
	) FollowUpDetails

END






GO


