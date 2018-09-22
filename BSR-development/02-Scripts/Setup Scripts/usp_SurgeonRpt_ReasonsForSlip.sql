
GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_ReasonsForSlip]    Script Date: 01/29/2016 12:27:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SurgeonRpt_ReasonsForSlip]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SurgeonRpt_ReasonsForSlip]
GO


GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_ReasonsForSlip]    Script Date: 01/29/2016 12:27:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_SurgeonRpt_ReasonsForSlip]
	@pSiteId int,
	@pSurgeonId int,
	@pOpDateFrom date,
	@pOpDateTo date,
	@pIsForSE int,
	@pRunForLegacyOnly int
AS
BEGIN		
 
    declare @DftDate as datetime
	set @DftDate = '01/01/1940';

	
    		
SELECT  * FROM 
(
		
	select rs.Description Reason , count(Pri.OpId) Primary_Pat,  count(Rev.OpId) Rev_Pat 
	from tbl_FollowUp f 	
	inner join tlkp_ReasonSlip rs on rs.Id = f.FurtherInfoSlip 
	inner join tbl_Patient p on p.PatId = f.PatientId 	
	left outer join tbl_PatientOperation Pri on Pri.OpId = f.OperationId and pri.OpStat =0 and Pri.OpVal =2  
	     and CONVERT(datetime, OpDate, 103) >= case when @pOpDateFrom <> @DftDate then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, OpDate, 103) end
		 and CONVERT(datetime, OpDate, 103) <= case when @pOpDateTo <> @DftDate then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, OpDate, 103) end
		 and Hosp = case when @pSiteId > 0 then @pSiteId else Hosp end
	left outer join tbl_PatientOperation Rev on Rev.OpId = f.OperationId and Rev.OpStat =1  and Rev.OpVal =2 
	    and CONVERT(datetime, Rev.OpDate, 103) >= case when @pOpDateFrom <> @DftDate then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, Rev.OpDate, 103) end
		and CONVERT(datetime, Rev.OpDate, 103) <= case when @pOpDateTo <> @DftDate then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, Rev.OpDate, 103) end
		and Rev.Hosp = case when @pSiteId > 0 then @pSiteId else Rev.Hosp end
	where 
	  ISNULL(f.FUVal,0) = 2	 and
	  coalesce(p.OptOffStatId, 0) in (0,2,4) 
	 and 
	 (case when @pIsForSE =1 then (coalesce(f.SEID1, 0) )  else coalesce(f.ReOpStatID, 0) end > 0 or 
	  case when @pIsForSE =1 then (coalesce(f.SEID2, 0) )  else coalesce(f.ReOpStatID, 0) end > 0 or
	  case when @pIsForSE =1 then (coalesce(f.SEID3, 0) )  else coalesce(f.ReOpStatID, 0) end > 0)	
	 and p.PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else p.PriSurgId end 
	 and coalesce(p.Legacy, 0) = (case when @pRunForLegacyOnly < 2 then @pRunForLegacyOnly else coalesce(p.Legacy, 0)  end)	 		
	group by rs.Description
	having  count(Pri.OpId) > 0 or count(Rev.OpId)  > 0
)SurgeonRpt_Reason

	RETURN 
END





GO


