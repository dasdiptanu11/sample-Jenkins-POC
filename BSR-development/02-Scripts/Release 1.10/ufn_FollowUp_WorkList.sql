
GO

/****** Object:  UserDefinedFunction [dbo].[ufn_FollowUp_WorkList]    Script Date: 06/17/2016 10:04:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ufn_FollowUp_WorkList]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ufn_FollowUp_WorkList]
GO


GO

/****** Object:  UserDefinedFunction [dbo].[ufn_FollowUp_WorkList]    Script Date: 06/17/2016 10:04:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[ufn_FollowUp_WorkList]
(
	@pSurgeonId int, 
	@pSiteId int, 
	@pOpDateFrom DateTime, --Uses mm/dd/yyyy format
	@pOpDateTo DateTime,   --Uses mm/dd/yyyy format 
	@PatID int,
	@OpVal int
)
RETURNS 
@patientTable TABLE 
(
		
	patID INT NOT NULL,
	HospID INT NOT NULL,
	SurgeonID INT NOT NULL,
	FName VARCHAR(50), 
	LName VARCHAR(50), 
	Gender VARCHAR(50),
	DOBNotKnown INT, 
	DOB datetime, 
	OperationDate datetime, 
	OperationStatus INT, 
	OperationType VARCHAR(50), 
	FollowUpPeriodInDays INT,
	FollowUpPeriod VARCHAR(50), 
	FollowUpNumber INT,	
	FollowUpStatus VARCHAR(50), 
	AttemptedCalls INT, 
	FUDate datetime,
	URNo VARCHAR(16),
	Surgeon Varchar(256),
	FollowUpID INT,
	OperationID INT NOT NULL,
	PrimarySurgeonID INT NOT NULL,
	PrimarySurgeon Varchar(256) NOT NULL,
	OpFormValidated int NOT NULL, 
	SiteTypeID int NOT NULL
)
AS
BEGIN
		declare @DftDate datetime
	    set @DftDate = '01/01/1940';
	    
	    --exec usp_UpdateFollowUpsAsInvalidOrValid;

		iNSERT INTO @patientTable 
		select p.PatId patID,ts.SiteId HospID, u1.UserId, p.FName FName,p.LastName LName,g.[Description] Gender,
			p.DOBNotKnown DOBNotKnown,p.DOB DOB,po.OpDate OperationDate,po.OpStat OperationStatus, os.[Description] OperationType,
			case when DateDiff(day, po.OpDate, GETDATE()) > 365 then 
							DateDiff(day, po.OpDate, GETDATE()) / 365 
							else 30 end FollowUpPeriodInDays,
		    fu1.[Description] FollowUpPeriod, 
		    DateDiff(day, po.OpDate, GETDATE()) / 365 FollowUpNumber,
		        case when fu1.Id = 0 and DateDiff(day, po.OpDate, GETDATE()) > 30 then 'Overdue' 
	         	else case when fu1.Id = 0 and DateDiff(day, po.OpDate, GETDATE()) <= 30 then 'Due' 
				else case when fu1.Id > 0 and GETDATE() between Dateadd(day, 365 * fu1.Id - 90, po.OpDate) and Dateadd(day, 365 * fu1.Id + 90, po.OpDate) then 'Due' 
				else case when fu1.Id > 0 and (DateDiff(day, po.OpDate, GETDATE()) - 365 * fu1.Id) > 90 then 'OverDue' 
				else ''
			end end end end FollowUpStatus,
		   fu2.Description AttemptedCalls,fu.FUDate FUDate, urn.URNo URNo, au1.UserName Surgeon, fu1.Id FollowUpID, po.OpId OperationID, p.PriSurgId, 
		   au1.UserName , po.OpVal OpFormValidated, coalesce(ts.SiteTypeId , 1)
		   from tbl_Patient p
		   inner  join tbl_FollowUp fu on p.PatId = fu.PatientId 
		   inner join  tlkp_Gender  g on p.GenderId = g.Id		   
		   inner join  tbl_PatientOperation po on fu.OperationId = OpId 
		   inner join tlkp_OperationStatus os on po.OpStat= os.Id 		   
		   inner join  tbl_Site ts on ts.SiteId  = po.Hosp 		  
		   inner join  tbl_URN urn on urn.PatientID = p.PatId and urn.HospitalID = ts.SiteId
		   inner join tbl_User u1 on u1.UserId = case when OpStat = 1 then po.Surg else PriSurgId end  --Surgeon should be operating surgeon if operation is revision else should be primary surgeon
		   inner join aspnet_Users au1 on au1.UserId = u1.UId  
		   inner join  tlkp_FollowUpPeriod fu1 on fu1.Id = fu.FUPeriodId
		   left outer join tlkp_AttemptedCalls fu2 on fu.AttmptCallId = fu2.Id 
		where 
		   coalesce(FUVal, 0) in (0,1) 
		   and po.OpVal = case when @OpVal <> -1 then @OpVal else po.OpVal end
		   and patID = case when @PatID <> -1 then @PatID else PatId end
		   and u1.UserId  = case when @pSurgeonId <> -1 then @pSurgeonId else u1.UserId end
		   and CONVERT(datetime, OpDate, 103) >= case when @pOpDateFrom <> @DftDate then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, OpDate, 103) end
		   and CONVERT(datetime, OpDate, 103) <= case when @pOpDateTo <> @DftDate then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, OpDate, 103) end		   
		   and SiteId  = case when @pSiteId <> -1 then @pSiteId else SiteId end

	RETURN 
END

--select * from tlkp_OptOffStatus 
















GO


