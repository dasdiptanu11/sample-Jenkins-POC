

/****** Object:  StoredProcedure [dbo].[usp_BenchMarkingReport]    Script Date: 09/18/2015 16:26:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_BenchMarkingReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_BenchMarkingReport]
GO

/****** Object:  StoredProcedure [dbo].[usp_BenchMarkingReport]    Script Date: 09/18/2015 16:26:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--/****** Object:  StoredProcedure [dbo].[usp_BenchMarkingReport]    Script Date: 04/15/2015 11:59:40 ******/
--IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_BenchMarkingReport]') AND type in (N'P', N'PC'))
--DROP PROCEDURE [dbo].[usp_BenchMarkingReport]
--GO

--/****** Object:  StoredProcedure [dbo].[usp_BenchMarkingReport]    Script Date: 04/15/2015 11:59:40 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--/*setting @pRunForLegacyOnly = 1  will run only for LegacyPatients only
--		  @pRunForLegacyOnly = 0  will run only for non - LegacyPatients only 
--		  @pRunForLegacyOnly = 2 will not consider isLegacyPatient field - runs for both   */

CREATE PROCEDURE [dbo].[usp_BenchMarkingReport]
    @pStateId int,
    @pCountryId int,
	@pSiteId int,
	@pSurgeonId int,
	@pOpTypeID int,
	@pRunForLegacyOnly int
AS
BEGIN

	declare @DftDate as datetime
	set @DftDate = '01/01/1940';
	
	  
		--Table1 : Selecting Initial Wt, Follow Up Wt, Follow Up Period ID, Ht and Primary Surgeon for all records from tbl_follow that 
		-- statify given input parameters   
		With tWtDtls(SurgeonID, StateID, CountryID,  FUPeriodId, InitialWt, FollowUpWt, Ht) as 
		(select p.PriSurgId , s.SiteStateId, s.SiteCountryId,FUPeriodId , 
		  case when coalesce(stWt,0) > coalesce(OpWt,0) then  coalesce(stWt,0) else coalesce(OpWt,0) end as InitialWt, 
		  coalesce(fuWt,0) followUpWt, coalesce(op.Ht,0)  from tbl_FollowUp fu 
		inner join tbl_PatientOperation op on op.OpId = fu.OperationId 
		inner join tbl_Patient p on p.PatId = op.PatientId 
		inner join tbl_Site  s on p.PriSiteId = s.SiteId
		where coalesce(FUVal,0) =2 and fuWt is not null and
			 coalesce(p.OptOffStatId, 0) in (0,2,4) and
			 coalesce(op.Opval, 0) = 2 and
		     p.PriSiteId  = case when @pSiteId > 0 then @pSiteId else p.PriSiteId end and
		     s.SiteStateId  = case when @pStateId > 0 then @pStateId else s.SiteStateId end and
		     s.SiteCountryId  = case when @pCountryId > 0 then @pCountryId else s.SiteCountryId end and
			 coalesce(op.Optype, 0) = case when @pOpTypeID > 0 and op.OpStat = 0 then @pOpTypeID else coalesce(op.Optype, 0) end and 
			 coalesce(op.OpRevType, 0) = case when @pOpTypeID > 0 and op.OpStat = 1 then @pOpTypeID else coalesce(op.OpRevType, 0) end and 
			 coalesce(p.Legacy, 0) = (case when @pRunForLegacyOnly = 0 then 0 else case when @pRunForLegacyOnly = 1 then 1 else coalesce(p.Legacy, 0) end end)
			),
			 
      --Table2 : Calculating WEIGHT loss for each record   			 
		WtLossDtls(SurgeonID, FUPeriodId, WtLoss, ExWtLoss) as
		(select SurgeonID, FUPeriodId,  
		        case when InitialWt = 0 then 0 else (InitialWt - FollowUpWt) end , 
		        case when (InitialWt = 0 Or Ht = 0) then 0 else (InitialWt  - (25 * Ht * Ht)) end from  tWtDtls),
	
		
		--Calculating average loss from table2 for given surgeon 
		EWL_sur(FUPeriodId_Sur, AvEWL_sur) as
		(select FUPeriodId,  case when FUPeriodId > 0 then (AVG( case when ExWtLoss = 0 then 0 else WtLoss * 100/ ExWtLoss end)) else 0 end from WtLossDtls 
		 where SurgeonID = case when @pSurgeonId > 0 then @pSurgeonId else SurgeonID end 
		 group by FUPeriodId)			
	
		
	SELECT  * FROM 
	(
		select FUPeriodId_Sur, cast(AvEWL_sur as decimal(10,2)) Surgeon from EWL_sur 
		inner join tlkp_FollowUpPeriod lfu on lfu.Id =  FUPeriodId_Sur
	)
BenchMarkingReport

END





GO


