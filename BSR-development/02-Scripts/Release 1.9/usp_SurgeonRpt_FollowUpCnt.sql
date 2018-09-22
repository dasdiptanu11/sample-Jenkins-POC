
GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_FollowUpCnt]    Script Date: 06/02/2016 11:51:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_SurgeonRpt_FollowUpCnt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_SurgeonRpt_FollowUpCnt]
GO


GO

/****** Object:  StoredProcedure [dbo].[usp_SurgeonRpt_FollowUpCnt]    Script Date: 06/02/2016 11:51:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






/*Calculates percentage of followUp completed each year by percentage of folow Ups that were due*/
/*setting @pRunForLegacyOnly = 1  will run only for LegacyPatients only
		  @pRunForLegacyOnly = 0  will run only for non - LegacyPatients only 
		  @pRunForLegacyOnly = 2 will not consider isLegacyPatient field - runs for both   */
CREATE PROCEDURE [dbo].[usp_SurgeonRpt_FollowUpCnt]
	@pSiteId int,
	@pSurgeonId int,
	@pOpDateFrom date,
	@pOpDateTo date, 
	@pRunForLegacyOnly int
AS
BEGIN	

	declare @DftDate as datetime
	set @DftDate = '01/01/1940';

	/*Fetches all follow Ups - due or pending*/	
	With tSurFollowUpDetails(FollowUP_Period_Sur, FUVal_Sur, Sur_FU_Cnt) as
		(select FUPeriodId , FUVal, coalesce(COUNT(*),0)   from tbl_FollowUp fu 
		        inner join tbl_PatientOperation o1 on o1.OpId = fu.OperationId 
		        inner join tbl_Patient p on o1.PatientId = p.PatId 
		        where 
		            coalesce(FUVal, 0) in (0,1,2)  
		            --and OpVal = 2 
					--and opStat = 0
		            and coalesce(p.OptOffStatId, 0)in (0,2,4) and p.PriSurgId  = case when @pSurgeonId > 0 then @pSurgeonId else p.PriSurgId   end
		   			--and CONVERT(datetime, OpDate, 103) >= case when @pOpDateFrom <> @DftDate then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, OpDate, 103) end
					and CONVERT(datetime, OpDate, 103) <= case when @pOpDateTo <> @DftDate then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, OpDate, 103) end
					and o1.Hosp = case when @pSiteId > 0 then @pSiteId else o1.Hosp end
					and coalesce(p.Legacy, 0) = (case when @pRunForLegacyOnly < 2 then @pRunForLegacyOnly else coalesce(p.Legacy, 0) end) 
				group by FUVal, FUPeriodId ), 
				
        --Follow Ups completed by surgeon each year     				
		tFollowsCompletedBySur(FU_Prd_Sur_Completed, FU_Cnt_Sur_Completed) as
		(select FollowUP_Period_Sur, SUM( Sur_FU_Cnt) from tSurFollowUpDetails where coalesce(FUVal_Sur, 0) =2  group by FollowUP_Period_Sur  ), 
		
		--Follow Ups due for surgeon each year
		tFollowUpsForSur(FU_Prd_Sur, Tot_Sur_FU_Cnt) as
		(select FollowUP_Period_Sur, SUM(Sur_FU_Cnt) from tSurFollowUpDetails group by FollowUP_Period_Sur), 
		
		--Follow Ups completed for surgeon in total
		tFUCom_Sur_BL(Sur_Completed_FU) as
		(select SUM( Sur_FU_Cnt) from tSurFollowUpDetails where coalesce(FUVal_Sur, 0) =2 ), 
		
		--Follow Ups due in registry
		tTotPat_Sur_BL(Tot_Sur_Pat) as
		(select SUM(Sur_FU_Cnt) from tSurFollowUpDetails), 
		
		--Follow Up count across registry for each year 			
		tRegFollowUpDetails(FollowUP_Period_Reg, FUVal_Reg, Reg_FU_Cnt) as
		(select FUPeriodId , FUVal, coalesce(COUNT(*),0)   from tbl_FollowUp fu 
		        inner join tbl_PatientOperation o1 on o1.OpId = fu.OperationId 
		        inner join tbl_Patient p on o1.PatientId = p.PatId 
		        where 
					coalesce(FUVal, 0) in (0,1,2)  
					--and OpVal = 2 
		            and coalesce(p.OptOffStatId, 0)in (0,2,4) 
		            --and CONVERT(datetime, OpDate, 103) >= case when @pOpDateFrom <> @DftDate then CONVERT(datetime, @pOpDateFrom, 103) else CONVERT(datetime, OpDate, 103) end
					and CONVERT(datetime, OpDate, 103) <= case when @pOpDateTo <> @DftDate then CONVERT(datetime, @pOpDateTo, 103) else CONVERT(datetime, OpDate, 103) end
					and o1.Hosp = case when @pSiteId > 0 then @pSiteId else o1.Hosp end
					and coalesce(p.Legacy, 0) = (case when @pRunForLegacyOnly < 2 then @pRunForLegacyOnly else coalesce(p.Legacy, 0) end) 
				group by FUVal, FUPeriodId ), 
		
		--Follow Up count completed in registry for each year 	
		tFollowsCompletedInReg(FU_Prd_Reg_Completed, FU_Cnt_Reg_Completed) as
		(select FollowUP_Period_Reg, SUM( Reg_FU_Cnt) from tRegFollowUpDetails where coalesce(FUVal_Reg, 0) =2 group by FollowUP_Period_Reg), 
		
		--Total Follow Ups in registry each year 	
		tFollowUpsInReg(FU_Prd_Reg, Tot_Reg_FU_Cnt) as
		(select FollowUP_Period_Reg, SUM(Reg_FU_Cnt) from tRegFollowUpDetails group by FollowUP_Period_Reg), 		
				
        --Total completed Follow Ups in reg
	    tFUCom_Reg_BL(Reg_Completed_FU) as
		(select SUM( Reg_FU_Cnt) from tRegFollowUpDetails where coalesce(FUVal_Reg, 0) =2 ), 
		
		--Total Follow Ups in reg
		tTotPat_Reg_BL(Tot_Reg_Pat) as
		(select SUM(Reg_FU_Cnt) from tRegFollowUpDetails), 	
							
       -- Follow Ups% completed by surgeon(% completed in registry) each year 				
		tFollowUpDetails(FollowUP_Period, FollowUp_Count_Percent) as
		(select FU_Prd_Reg , 
		     cast(cast (FU_Cnt_Sur_Completed * 100.00/(case when Tot_Sur_FU_Cnt = 0 then 1 else Tot_Sur_FU_Cnt end) as decimal(10, 1)) as varchar(20)) + '% (' 
		     + cast(cast (FU_Cnt_Reg_Completed * 100.00/(case when Tot_Reg_FU_Cnt = 0 then 1 else Tot_Reg_FU_Cnt end) as decimal(10, 1)) as varchar(20)) + '%)'
		  from tFollowsCompletedBySur inner join tFollowUpsForSur on FU_Prd_Sur_Completed = FU_Prd_Sur
		       inner join tFollowsCompletedInReg on FU_Prd_Reg_Completed = FU_Prd_Sur_Completed 
		       inner join tFollowUpsInReg on  FU_Prd_Reg = FU_Prd_Reg_Completed)				
		
		
SELECT  * FROM 
(
			select 
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
			( SELECT '' 'FU' ,  FollowUP_Period, FollowUp_Count_Percent from tFollowUpDetails) as S 
			PIVOT 
			   ( Max(FollowUp_Count_Percent) 
			   For FollowUP_Period IN ([0], [1], [2], [3], [4], [5], [6], [7], [8], [9], [10])
		 ) as FollowupDetails) FollowupDetails1  inner join tFUCom_Sur_BL on 'a' = 'a' inner join tTotPat_Sur_BL on 'a' = 'a' 
		 inner join tFUCom_Reg_BL on 'a' = 'a' inner join tTotPat_Reg_BL on 'a' = 'a'
)SurgeonRpt_FollowUpCnt

	RETURN 
END









GO


