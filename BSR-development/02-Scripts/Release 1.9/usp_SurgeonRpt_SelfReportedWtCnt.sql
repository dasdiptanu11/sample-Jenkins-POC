
GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_SelfReportedWtCnt]    Script Date: 06/02/2016 11:58:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SurgeonRpt_SelfReportedWtCnt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SurgeonRpt_SelfReportedWtCnt]
GO


GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_SelfReportedWtCnt]    Script Date: 06/02/2016 11:58:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*Gives % of patients that reported weights themselves in follow up years for a surgeon and compares it with registry value */
CREATE PROCEDURE [dbo].[usp_SurgeonRpt_SelfReportedWtCnt]
	@pSiteId int,
	@pSurgeonId int,
	@pOpDateFrom date,
	@pOpDateTo date,
	@pRunForLegacyOnly int
AS
BEGIN		
 
    declare @DftDate as datetime
	set @DftDate = '01/01/1940';

	With
	    /*Fetches all patients that fit into selected criteria for analysis*/
	  	tFU_SelfRptSW_Sur(FU_PeriodID, SWSelfReported, Sur, Cnt, FUVal) as
		(select FUPeriodId , coalesce(SelfRptWt, 0), p.PriSurgId  , COUNT(*) ,fu.Fuval
		 from tbl_FollowUp fu 
	        inner join tbl_PatientOperation o1 on o1.OpId = fu.OperationId 
	        inner join tbl_Patient p on p.PatId = o1.PatientId 
         where 
            coalesce(fu.Fuval, 0) in (0,1,2) 
            --and OpVal = 2
            and coalesce(p.OptOffStatId, 0) in (0,2,4) 
            and CONVERT(datetime, OpDate, 103) >= case when @pOpDateFrom <> @DftDate then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, OpDate, 103) end
			and CONVERT(datetime, OpDate, 103) <= case when @pOpDateTo <> @DftDate then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, OpDate, 103) end
			and o1.Hosp = case when @pSiteId > 0 then @pSiteId else o1.Hosp end
			and coalesce(p.Legacy, 0) = (case when @pRunForLegacyOnly < 2 then @pRunForLegacyOnly else coalesce(p.Legacy, 0) end)
		 group by SelfRptWt, FUPeriodId, p.PriSurgId, fu.Fuval ),	
	
		/*Total patients selected*/	
	    tTot_Reg_Pat(Tot_Reg_Pat_Cnt) as
		(select coalesce(COUNT(*), 0) from tFU_SelfRptSW_Sur),	
		
		/*Total patients selected belonging to choosen surgeon*/		
		tTot_Sur_Pat(Tot_Sur_Pat_Cnt) as
		(select coalesce(COUNT(*), 0)  from tFU_SelfRptSW_Sur 
	        where sur = case when @pSurgeonId > 0 then @pSurgeonId else sur end),	
				
		/*Followups done by surgeon in an year*/
		tNetFollowUp_Sur(Sur_FollowUP_Period, Sur_FollowUp_Cnt_In_Year) as
		(select FU_PeriodID , coalesce(SUM(Cnt), 0)  from tFU_SelfRptSW_Sur where FUVal = 2 and 
		        Sur = case when @pSurgeonId > 0 then @pSurgeonId else Sur end group by FU_PeriodID  ),	
		
		/*Followups done by surgeon in an year that have self reported weights*/
		tSWFollowUp_Sur(Sur_SW_FollowYrID, Sur_SW_Cnt_In_Year) as
		(select FU_PeriodID , coalesce(SUM(Cnt), 0) from tFU_SelfRptSW_Sur where 
		      Sur = case when @pSurgeonId > 0 then @pSurgeonId else Sur end and SWSelfReported = 1 group by FU_PeriodID ),	
		
		/*Followups done by surgeon till now that have self reported weights*/
		tBLFollowUp_Sur(Sur_BL_Cnt) as
		(select coalesce(SUM(Cnt), 0) from tFU_SelfRptSW_Sur where 
		      Sur = case when @pSurgeonId > 0 then @pSurgeonId else Sur end and SWSelfReported = 1),	      
		  
		 /*Total follow ups in registry*/ 
		tNetFollowUp_Reg(Reg_FollowYrID, Reg_FollowUp_Cnt_In_Year) as
		(select FU_PeriodID ,coalesce(SUM(Cnt), 0) from tFU_SelfRptSW_Sur where FUVal = 2 group by FU_PeriodID ),				    		  		  
	
	    /*Total follow ups in registry that have self reported weights*/ 	
		tSWFollowUp_Reg(Reg_SW_FollowYrID, Reg_SW_Cnt_In_Year) as
		(select FU_PeriodID , coalesce(SUM(Cnt), 0) from tFU_SelfRptSW_Sur where SWSelfReported = 1 group by FU_PeriodID ),		
		
		/*Total followUps in reg*/
		tBLFollowUp_Reg(Reg_BL_Cnt) as
		(select SUM(Cnt) from tFU_SelfRptSW_Sur where SWSelfReported = 1),				
		
	    /*% of sw reported follow up done by surgeon as compared to % in registry for each FU year */
		tSelfReportedSWDtls(FollowUP_Period, SW_Count_percent) as
		(select Sur_FollowUP_Period, 
		       cast(cast((Sur_SW_Cnt_In_Year * 100.00)/Sur_FollowUp_Cnt_In_Year as decimal(5,1)) as varchar(20)) + '% (' 
		       + cast(cast((Reg_SW_Cnt_In_Year * 100.00)/Reg_FollowUp_Cnt_In_Year as decimal(5,1)) as varchar(20)) + '%)'
		      from tSWFollowUp_Sur inner join tSWFollowUp_Reg on   Sur_SW_FollowYrID =  Reg_SW_FollowYrID
		      inner join tNetFollowUp_Sur on Sur_FollowUP_Period = Sur_SW_FollowYrID 
		      inner join tNetFollowUp_Reg on Reg_FollowYrID = Reg_SW_FollowYrID)
		
SELECT  * FROM 
(
		select 
		 /*cast(cast((Sur_BL_Cnt * 100.00)/Tot_Sur_Pat_Cnt as decimal(5,1)) as varchar(20)) + '%(' 
		      + cast(cast((Reg_BL_Cnt * 100.00)/Tot_Reg_Pat_Cnt as decimal(5,1)) as varchar(20)) + '%)' as BaseLine, */
		  coalesce(FollowupDetails1.[0], '') as BaseLine, 
		  coalesce(FollowupDetails1.[1], '') as Year_1, 
		  coalesce(FollowupDetails1.[2], '') as Year_2, 
		  coalesce(FollowupDetails1.[3], '') as Year_3, 
		  coalesce(FollowupDetails1.[4], '') as Year_4, 
		  coalesce(FollowupDetails1.[5], '') as Year_5, 
		  coalesce(FollowupDetails1.[6], '') as Year_6, 
		  coalesce(FollowupDetails1.[7], '') as Year_7, 
		  coalesce(FollowupDetails1.[8], '') as Year_8, 
		  coalesce(FollowupDetails1.[9], '') as Year_9, 
		  coalesce(FollowupDetails1.[10], '') as Year_10
		from 
		(SELECT * FROM 
			( SELECT 'SW' SelfReportedWt  ,  FollowUP_Period, SW_Count_percent from tSelfReportedSWDtls) as S 
			PIVOT 
			   ( max(SW_Count_percent) 
			   For FollowUP_Period IN ([0], [1], [2], [3], [4], [5], [6], [7], [8], [9], [10])
		 ) as FollowupDetails) FollowupDetails1 left outer join tTot_Reg_Pat on 'a' ='a' 
		 left outer join tTot_Sur_Pat on 'a' ='a'  left outer join tBLFollowUp_Reg on 'a' ='a'  
		left outer join tBLFollowUp_Sur on 'a' ='a' 
		 
		 
)SurgeonRpt_SelfReportedWtCnt

	RETURN 
END






GO


