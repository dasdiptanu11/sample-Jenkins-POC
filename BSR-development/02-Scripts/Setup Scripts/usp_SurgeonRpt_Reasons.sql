
GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_Reasons]    Script Date: 01/25/2016 14:22:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SurgeonRpt_Reasons]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SurgeonRpt_Reasons]
GO


GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_Reasons]    Script Date: 01/25/2016 14:22:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/*Generates count of Patients for each type of operation and SE reason */
CREATE PROCEDURE [dbo].[usp_SurgeonRpt_Reasons]
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
	
		
With t_Comp(PatId, Operation, Reason) as
(select f.PatientId , f.OperationId , com.Description 
 from tbl_FollowUp f 
 inner join tbl_PatientComplications c on f.FUId = c.FuId 
 inner join tlkp_Complications com on c.ComplicationId = com.Id 
 where 
 (case when @pIsForSE =1 then (coalesce(f.SEID1, 0) )  else coalesce(f.ReOpStatID, 0) end > 0 or 
  case when @pIsForSE =1 then (coalesce(f.SEID2, 0) )  else coalesce(f.ReOpStatID, 0) end > 0 or
  case when @pIsForSE =1 then (coalesce(f.SEID3, 0) )  else coalesce(f.ReOpStatID, 0) end > 0) 
  and FUVal = 2),
t_rev (revReason, revPat) as
(select Reason, COUNT(distinct OpId) from t_Comp 
	inner join tbl_Patient p on t_Comp.PatId = p.PatId 
	inner join tbl_PatientOperation op on t_Comp.Operation = op.OpId   
	where --OpVal =2 and  OpStat =1 and 
	   coalesce(p.OptOffStatId, 0)in (0,2,4)
	   and p.PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else p.PriSurgId end 
	   and CONVERT(datetime, op.OpDate, 103) >= case when @pOpDateFrom <> @DftDate 
				then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, op.OpDate, 103) end
	   and CONVERT(datetime, op.OpDate, 103) <= case when @pOpDateTo <> @DftDate 
				then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, op.OpDate, 103) end
       and op.Hosp  = case when @pSiteId > 0 then @pSiteId else op.Hosp end 
	   and coalesce(p.Legacy, 0) = (case when @pRunForLegacyOnly < 2 then @pRunForLegacyOnly else coalesce(p.Legacy, 0) end)
	group by Reason), 
t_pri (priReason, priPat) as
(select Reason, COUNT(distinct OpId) from t_Comp 
	inner join tbl_Patient p on t_Comp.PatId = p.PatId 
	inner join tbl_PatientOperation op on t_Comp.Operation = op.OpId 
	where --OpVal =2 and  OpStat =0 and 
	coalesce(p.OptOffStatId, 0)in (0,2,4)
	and p.PriSurgId = case when @pSurgeonId > 0 then @pSurgeonId else p.PriSurgId end 
	and CONVERT(datetime, op.OpDate, 103) >= case when @pOpDateFrom <> @DftDate 
			then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, op.OpDate, 103) end
    and CONVERT(datetime, op.OpDate, 103) <= case when @pOpDateTo <> @DftDate 
			then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, op.OpDate, 103) end
    and op.Hosp  = case when @pSiteId > 0 then @pSiteId else op.Hosp end 
	   and coalesce(p.Legacy, 0) = (case when @pRunForLegacyOnly < 2 then @pRunForLegacyOnly else coalesce(p.Legacy, 0) end)
	group by Reason)    
	    		
SELECT  * FROM 
(	
	select com.Description Reason ,coalesce(priPat, 0) Primary_Pat ,  coalesce(revPat, 0) Rev_Pat from tlkp_Complications com 
	  left outer join t_rev on com.Description = revReason
	  left outer join t_pri on com.Description = priReason
	  where coalesce(priPat, 0) > 0 or coalesce(revPat, 0) > 0
	
)SurgeonRpt_Reason

	RETURN 
END








GO


